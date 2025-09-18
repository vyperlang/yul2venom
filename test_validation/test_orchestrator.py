#!/usr/bin/env python3
"""
Main test orchestrator for end-to-end validation of Yul-to-Venom transpilation.
"""

import sys
import json
import time
import traceback
from pathlib import Path
from typing import Dict, List, Optional, Tuple, Any
from dataclasses import dataclass, asdict
from datetime import datetime

# Add parent directory to path
sys.path.insert(0, str(Path(__file__).parent.parent))

from test_validation.runners.solc_compiler import SolcCompiler
from test_validation.runners.yul_transpiler import YulTranspiler
from test_validation.validators.execution_validator import ExecutionValidator, ValidationResult
from eth_abi import encode
from test_validation.test_cases import get_test_cases_for_contract, get_simple_test_cases


@dataclass
class TestCase:
    """Test case definition."""
    name: str
    solidity_file: Path
    description: str
    tags: List[str]
    expected_result: str = "pass"
    
    def __str__(self):
        return f"{self.name}: {self.description}"


@dataclass
class TestResult:
    """Result of a single test execution."""
    test_case: TestCase
    status: str  # "pass", "fail", "error", "skip"
    duration: float  # seconds
    validation_reports: List[Any]
    error_message: Optional[str] = None
    yul_size: Optional[int] = None
    bytecode_size: Optional[int] = None
    venom_ir_size: Optional[int] = None
    
    def to_dict(self):
        """Convert to dictionary for JSON serialization."""
        result = asdict(self)
        result['test_case'] = asdict(self.test_case)
        result['test_case']['solidity_file'] = str(self.test_case.solidity_file)
        return result


class TestOrchestrator:
    """Orchestrates end-to-end testing of the transpilation pipeline."""
    
    def __init__(self, 
                 solc_path: str = "solc",
                 vyper_path: str = "/Users/harkal/projects/charles_cooper/repos/vyper",
                 fixtures_dir: Optional[Path] = None):
        """
        Initialize the TestOrchestrator.
        
        Args:
            solc_path: Path to solc binary
            vyper_path: Path to Vyper repository
            fixtures_dir: Path to fixtures directory
        """
        self.solc_compiler = SolcCompiler(solc_path)
        self.yul_transpiler = YulTranspiler(vyper_path)
        self.execution_validator = ExecutionValidator()
        
        if fixtures_dir:
            self.fixtures_dir = fixtures_dir
        else:
            self.fixtures_dir = Path(__file__).parent / "fixtures"
        
        self.results: List[TestResult] = []
    
    def discover_tests(self) -> List[TestCase]:
        """
        Discover test cases from fixtures directory.
        
        Returns:
            List of test cases
        """
        test_cases = []
        solidity_dir = self.fixtures_dir / "solidity"
        
        if not solidity_dir.exists():
            return test_cases
        
        # Define test cases with metadata
        test_definitions = [
            {
                "file": "BasicMath.sol",
                "name": "basic_math",
                "description": "Test basic math without strings",
                "tags": ["math", "simple", "basic"]
            },
            {
                "file": "SimpleStorage.sol",
                "name": "simple_storage",
                "description": "Test basic storage operations",
                "tags": ["storage", "events", "basic"]
            },
            {
                "file": "Arithmetic.sol",
                "name": "arithmetic",
                "description": "Test arithmetic operations",
                "tags": ["arithmetic", "pure", "basic"]
            },
            {
                "file": "ControlFlow.sol",
                "name": "control_flow",
                "description": "Test control flow structures",
                "tags": ["control", "loops", "conditions"]
            }
        ]
        
        for test_def in test_definitions:
            sol_file = solidity_dir / test_def["file"]
            if sol_file.exists():
                test_cases.append(TestCase(
                    name=test_def["name"],
                    solidity_file=sol_file,
                    description=test_def["description"],
                    tags=test_def["tags"]
                ))
        
        # Also discover any additional .sol files
        for sol_file in solidity_dir.glob("*.sol"):
            # Skip if already in test_definitions
            if not any(sol_file.name == td["file"] for td in test_definitions):
                test_cases.append(TestCase(
                    name=sol_file.stem.lower(),
                    solidity_file=sol_file,
                    description=f"Test {sol_file.stem}",
                    tags=["auto-discovered"]
                ))
        
        return test_cases
    
    def run_test(self, test_case: TestCase) -> TestResult:
        """
        Run a single test case.
        
        Args:
            test_case: Test case to run
        
        Returns:
            Test result
        """
        start_time = time.time()
        
        try:
            print(f"\n{'='*60}")
            print(f"Running test: {test_case.name}")
            print(f"Description: {test_case.description}")
            print(f"Solidity file: {test_case.solidity_file}")
            print(f"{'='*60}")
            
            # Step 1: Compile Solidity to Yul
            print("\n[1/5] Compiling Solidity to Yul...")
            yul_code = self.solc_compiler.compile_to_yul(test_case.solidity_file)
            yul_size = len(yul_code)
            print(f"  [OK] Generated Yul code: {yul_size} bytes")
            
            # Save Yul for debugging
            yul_file = self.fixtures_dir / "yul" / f"{test_case.name}.yul"
            yul_file.parent.mkdir(exist_ok=True)
            with open(yul_file, 'w') as f:
                f.write(yul_code)
            print(f"  [OK] Saved Yul to: {yul_file}")
            
            # Step 2: Compile Solidity to bytecode (for comparison)
            print("\n[2/5] Compiling Solidity to bytecode (reference)...")
            deploy_bytecode, runtime_bytecode = self.solc_compiler.compile_to_bytecode(
                test_case.solidity_file
            )
            print(f"  [OK] Deployment bytecode: {len(deploy_bytecode)} chars")
            print(f"  [OK] Runtime bytecode: {len(runtime_bytecode)} chars")

            # Compute constructor args (default zero values) using solc JSON ABI
            ctor_args = b""
            try:
                solc_json = self.solc_compiler.compile_to_json(test_case.solidity_file)
                # solc JSON: contracts[filename][contractName]
                contracts = solc_json.get("contracts", {}).get(test_case.solidity_file.name, {})
                # Prefer first contract entry (test files contain one contract)
                for _name, item in contracts.items():
                    abi = item.get("abi", [])
                    ctor = next((e for e in abi if e.get("type") == "constructor"), None)
                    if ctor is None or not ctor.get("inputs"):
                        break
                    types = [inp["type"] for inp in ctor["inputs"]]
                    # Provide zero-like defaults per type
                    def _default_for(t: str):
                        if t.startswith("uint") or t.startswith("int"):
                            return 0
                        if t == "address":
                            return b"\x00" * 20
                        if t == "bool":
                            return False
                        if t == "bytes" or t.startswith("bytes"):
                            # static bytesN: encode_abi expects bytes
                            return b"\x00" * (int(t[5:]) if t.startswith("bytes") and len(t) > 5 else 0)
                        if t == "string":
                            return ""
                        if t.endswith("[]"):
                            return []
                        # Fallback: zero
                        return 0
                    values = [_default_for(t) for t in types]
                    ctor_args = encode(types, values)
                    break
            except Exception:
                # If ABI encoding fails, continue with empty args
                ctor_args = b""
            
            # Step 3: Transpile Yul to Venom IR
            print("\n[3/5] Transpiling Yul to Venom IR...")
            venom_ir = self.yul_transpiler.compile_yul_to_venom_ir(yul_code)
            venom_ir_size = len(venom_ir)
            print(f"  [OK] Generated Venom IR: {venom_ir_size} bytes")
            
            # Step 4: Generate bytecode from Venom
            print("\n[4/5] Generating bytecode from Venom...")
            transpiled_bytecode = self.yul_transpiler.compile_yul_to_bytecode(yul_code)
            bytecode_size = len(transpiled_bytecode)
            print(f"  [OK] Generated bytecode: {bytecode_size} chars")
            
            # Step 5: Validate bytecode through execution
            print("\n[5/5] Validating bytecode through execution...")
            
            # Get test cases for this contract
            test_cases = get_test_cases_for_contract(test_case.name)
            if not test_cases:
                # Use simple test cases if no specific ones defined
                test_cases = get_simple_test_cases()
                print(f"  Using simple test cases (no specific tests for {test_case.name})")
            else:
                print(f"  Running {len(test_cases)} test cases for {test_case.name}")
            
            validation_reports = self.execution_validator.validate_execution(
                deploy_bytecode, 
                transpiled_bytecode,
                test_cases,
                constructor_args=ctor_args,
            )
            
            # Print validation results
            for report in validation_reports:
                symbol = "[OK]" if report.status == ValidationResult.PASS else "[FAIL]"
                print(f"  {symbol} {report.test_name}: {report.message}")
            
            # Determine overall status
            failed_count = sum(1 for r in validation_reports 
                             if r.status == ValidationResult.FAIL)
            error_count = sum(1 for r in validation_reports
                            if r.status == ValidationResult.ERROR)
            
            if failed_count == 0 and error_count == 0:
                status = "pass"
                print(f"\n==> Test PASSED")
            elif error_count > 0:
                status = "error"
                print(f"\n==> Test ERROR ({error_count} execution errors)")
            else:
                status = "fail"
                print(f"\n==> Test FAILED ({failed_count} validation failures)")
            
            duration = time.time() - start_time
            
            return TestResult(
                test_case=test_case,
                status=status,
                duration=duration,
                validation_reports=[r.__dict__ for r in validation_reports],
                yul_size=yul_size,
                bytecode_size=bytecode_size,
                venom_ir_size=venom_ir_size
            )
            
        except Exception as e:
            duration = time.time() - start_time
            error_msg = f"{type(e).__name__}: {str(e)}\n{traceback.format_exc()}"
            print(f"\n==> Test ERROR: {error_msg}")
            
            return TestResult(
                test_case=test_case,
                status="error",
                duration=duration,
                validation_reports=[],
                error_message=error_msg
            )
    
    def run_all_tests(self, test_filter: Optional[List[str]] = None) -> None:
        """
        Run all discovered tests.
        
        Args:
            test_filter: Optional list of test names to run
        """
        test_cases = self.discover_tests()
        
        if test_filter:
            test_cases = [tc for tc in test_cases if tc.name in test_filter]
        
        print(f"\n{'='*60}")
        print(f"Discovered {len(test_cases)} test cases")
        print(f"{'='*60}")
        
        for i, test_case in enumerate(test_cases, 1):
            print(f"\n[{i}/{len(test_cases)}] {test_case}")
            result = self.run_test(test_case)
            self.results.append(result)
    
    def generate_report(self, output_file: Optional[Path] = None) -> Dict[str, Any]:
        """
        Generate a test report.
        
        Args:
            output_file: Optional file to save report to
        
        Returns:
            Report dictionary
        """
        report = {
            "timestamp": datetime.now().isoformat(),
            "solc_version": self.solc_compiler.get_version(),
            "total_tests": len(self.results),
            "passed": sum(1 for r in self.results if r.status == "pass"),
            "failed": sum(1 for r in self.results if r.status == "fail"),
            "errors": sum(1 for r in self.results if r.status == "error"),
            "skipped": sum(1 for r in self.results if r.status == "skip"),
            "total_duration": sum(r.duration for r in self.results),
            "results": [r.to_dict() for r in self.results]
        }
        
        if len(self.results) > 0:
            report["success_rate"] = report["passed"] / report["total_tests"]
        else:
            report["success_rate"] = 0.0
        
        if output_file:
            with open(output_file, 'w') as f:
                json.dump(report, f, indent=2)
            print(f"\nReport saved to: {output_file}")
        
        return report
    
    def print_summary(self) -> None:
        """Print a summary of test results."""
        report = self.generate_report()
        
        print(f"\n{'='*60}")
        print("TEST SUMMARY")
        print(f"{'='*60}")
        print(f"Total tests:    {report['total_tests']}")
        print(f"Passed:         {report['passed']} ({report['passed']/max(1, report['total_tests'])*100:.1f}%)")
        print(f"Failed:         {report['failed']}")
        print(f"Errors:         {report['errors']}")
        print(f"Skipped:        {report['skipped']}")
        print(f"Success rate:   {report['success_rate']*100:.1f}%")
        print(f"Total duration: {report['total_duration']:.2f}s")
        print(f"{'='*60}")
        
        # Print failed tests
        if report['failed'] > 0 or report['errors'] > 0:
            print("\nFailed/Error Tests:")
            for result in self.results:
                if result.status in ["fail", "error"]:
                    print(f"  - {result.test_case.name}: {result.status}")
                    if result.error_message:
                        print(f"    Error: {result.error_message.split(chr(10))[0]}")


def main():
    """Main entry point for test orchestrator."""
    import argparse
    
    parser = argparse.ArgumentParser(description="Yul-to-Venom Test Orchestrator")
    parser.add_argument("--filter", nargs="+", help="Filter tests by name")
    parser.add_argument("--report", help="Save report to file")
    parser.add_argument("--solc", default="solc", help="Path to solc binary")
    parser.add_argument("--vyper", 
                       default="/Users/harkal/projects/charles_cooper/repos/vyper",
                       help="Path to Vyper repository")
    
    args = parser.parse_args()
    
    orchestrator = TestOrchestrator(
        solc_path=args.solc,
        vyper_path=args.vyper
    )
    
    try:
        orchestrator.run_all_tests(test_filter=args.filter)
        orchestrator.print_summary()
        
        if args.report:
            orchestrator.generate_report(Path(args.report))
        
        # Exit with appropriate code
        if any(r.status in ["fail", "error"] for r in orchestrator.results):
            sys.exit(1)
        else:
            sys.exit(0)
            
    except KeyboardInterrupt:
        print("\n\nTest run interrupted by user")
        sys.exit(130)
    except Exception as e:
        print(f"\n\nFatal error: {e}")
        traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()
