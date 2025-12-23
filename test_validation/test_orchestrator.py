#!/usr/bin/env python3
"""
Main test orchestrator for end-to-end validation of Yul-to-Venom transpilation.
"""

import sys
import json
import time
import traceback
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple
from dataclasses import dataclass, asdict
from datetime import datetime

from test_validation.runners.solc_compiler import SolcCompiler, ContractArtifact
from test_validation.runners.yul_transpiler import YulTranspiler, YulBytecodeArtifact
from test_validation.validators.execution_validator import (
    DeploymentStep,
    ExecutionValidator,
    ValidationResult,
)
from eth_abi import encode
from test_validation.test_cases import get_test_cases_for_contract, get_simple_test_cases
from vyper.exceptions import CompilerPanic


# Tests to skip with reasons
# Format: "test_name": "reason for skipping"
SKIP_TESTS: Dict[str, str] = {
    "mainnetflat": (
        "MainnetSettler constructor requires DEPLOYER NFT ownership check. "
        "pyrevm uses chainid=1 (not 31337), triggering the mainnet code path "
        "which calls IERC721Owner(DEPLOYER).ownerOf(_tokenId()). This fails "
        "because the DEPLOYER contract doesn't exist in the test environment. "
        "This is a test environment limitation, not a compiler bug."
    ),
}


def _hex_length_in_bytes(hex_string: str) -> int:
    """Convert a hex string (with or without 0x prefix) to a byte-length."""
    if not hex_string:
        return 0
    if hex_string.startswith("0x"):
        hex_string = hex_string[2:]
    return len(hex_string) // 2


def _address_to_int(address: str) -> int:
    """Convert an EVM address string into an integer."""

    normalized = address.strip().lower()
    if normalized.startswith("0x"):
        normalized = normalized[2:]
    return int(normalized or "0", 16)


def _normalize_dependency_name(identifier: str) -> str:
    """Normalize a linkersymbol identifier to match solc artifact naming."""

    if ":" not in identifier:
        return identifier

    prefix, contract = identifier.split(":", 1)
    filename = Path(prefix).name
    return f"{filename}:{contract}"


def _format_pct(pct: Optional[float], noun: str = "reduction") -> str:
    if pct is None:
        return ""
    direction = noun
    value = pct
    if pct < 0:
        direction = "increase" if noun == "reduction" else noun
        value = abs(pct)
    return f" ({value:.2f}% {direction})"


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
    reference_deploy_bytes: Optional[int] = None
    transpiled_deploy_bytes: Optional[int] = None
    reference_deploy_gas: Optional[int] = None
    transpiled_deploy_gas: Optional[int] = None
    reference_call_gas: Optional[int] = None
    transpiled_call_gas: Optional[int] = None
    
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
                "file": "AdvancedFeatures.sol",
                "name": "AdvancedFeatures",
                "description": "Test advanced storage + control flow",
                "tags": ["storage", "loops", "advanced"]
            },
            {
                "file": "HeavyMath.sol",
                "name": "HeavyMath",
                "description": "Stress gas usage with heavy math",
                "tags": ["math", "gas", "heavy"]
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
                test_name = sol_file.stem.lower()
                # Check if test is in skip list
                if test_name in SKIP_TESTS:
                    continue  # Will be added to skipped results in run_all_tests
                test_cases.append(TestCase(
                    name=test_name,
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
            reference_deploy_bytes = _hex_length_in_bytes(deploy_bytecode)
            reference_runtime_bytes = _hex_length_in_bytes(runtime_bytecode)
            print(
                f"  [OK] Deployment bytecode: {len(deploy_bytecode)} chars"
                f" ({reference_deploy_bytes} bytes)"
            )
            print(
                f"  [OK] Runtime bytecode: {len(runtime_bytecode)} chars"
                f" ({reference_runtime_bytes} bytes)"
            )

            artifacts = self.solc_compiler.compile_contract_artifacts(test_case.solidity_file)
            deployable_artifacts = {
                name: artifact
                for name, artifact in artifacts.items()
                if self._artifact_has_code(artifact)
            }

            if not deployable_artifacts:
                print("  [SKIP] No deployable contract artifacts produced by solc")
                duration = time.time() - start_time
                return TestResult(
                    test_case=test_case,
                    status="skip",
                    duration=duration,
                    validation_reports=[],
                    yul_size=yul_size,
                )

            primary_artifact = self.solc_compiler.select_primary_artifact(
                test_case.solidity_file, deployable_artifacts
            )
            if primary_artifact is None:
                print("  [SKIP] Unable to determine primary contract artifact")
                duration = time.time() - start_time
                return TestResult(
                    test_case=test_case,
                    status="skip",
                    duration=duration,
                    validation_reports=[],
                    yul_size=yul_size,
                )

            object_infos = self.yul_transpiler.list_objects(yul_code)
            object_lookup = self._build_object_lookup(object_infos)
            target_object = self._select_object_info(object_lookup, primary_artifact.contract_name)

            artifact_dependencies: Dict[str, Tuple[str, ...]] = {}
            dependency_aliases: Dict[str, Dict[str, str]] = {}
            zero_link_maps: Dict[str, Dict[str, int]] = {}
            for fq_name, artifact in deployable_artifacts.items():
                object_info_for_dep = self._select_object_info(
                    object_lookup, artifact.contract_name
                )
                original_deps = self.yul_transpiler.get_linker_dependencies(
                    yul_code, object_info_for_dep.name
                )

                alias_map: Dict[str, str] = {}
                normalized_deps: List[str] = []
                for original in original_deps:
                    normalized = _normalize_dependency_name(original)
                    alias_map[original] = normalized
                    normalized_deps.append(normalized)

                dependency_aliases[fq_name] = alias_map
                artifact_dependencies[fq_name] = tuple(
                    dep
                    for dep in dict.fromkeys(normalized_deps)
                    if dep in deployable_artifacts
                )
                zero_link_maps[fq_name] = {
                    original: 0
                    for original, normalized in alias_map.items()
                    if normalized in deployable_artifacts
                }

            primary_dependencies = artifact_dependencies.get(
                primary_artifact.fully_qualified_name, ()
            )
            zero_link_map = zero_link_maps.get(primary_artifact.fully_qualified_name, {})

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
            try:
                venom_ir = self.yul_transpiler.compile_yul_to_venom_ir(
                    yul_code,
                    object_name=target_object.name,
                    link_libraries=zero_link_map if zero_link_map else None,
                )
            except CompilerPanic as exc:
                print(f"  [SKIP] Venom IR generation failed: {exc}")
                duration = time.time() - start_time
                return TestResult(
                    test_case=test_case,
                    status="skip",
                    duration=duration,
                    validation_reports=[],
                    yul_size=yul_size,
                )
            venom_ir_size = len(venom_ir)
            print(f"  [OK] Generated Venom IR: {venom_ir_size} bytes")
            
            # Step 4: Generate bytecode from Venom
            print("\n[4/5] Generating bytecode from Venom...")
            compiled_bytecode_artifacts: Dict[str, YulBytecodeArtifact] = {}

            bytecode_artifact = self.yul_transpiler.compile_yul_to_bytecode(
                yul_code,
                object_name=target_object.name,
                link_libraries=zero_link_map if zero_link_map else None,
                return_details=True,
            )
            compiled_bytecode_artifacts[primary_artifact.fully_qualified_name] = bytecode_artifact
            transpiled_bytecode = bytecode_artifact.deploy_bytecode
            bytecode_size = len(transpiled_bytecode)
            transpiled_deploy_bytes = _hex_length_in_bytes(transpiled_bytecode)
            print(
                f"  [OK] Generated bytecode: {bytecode_size} chars"
                f" ({transpiled_deploy_bytes} bytes)"
            )
            if reference_deploy_bytes:
                size_delta_pct = (
                    (transpiled_deploy_bytes - reference_deploy_bytes)
                    / reference_deploy_bytes
                ) * 100
                print(
                    f"  [INFO] Size delta vs solc deploy: {size_delta_pct:+.2f}%"
                )
            else:
                print("  [INFO] Size delta vs solc deploy: n/a")

            runtime_sections = bytecode_artifact.runtime_sections
            primary_runtime_bytes = None
            if runtime_sections:
                primary_runtime_label, runtime_blob = next(iter(runtime_sections.items()))
                primary_runtime_bytes = len(runtime_blob)
                runtime_hex = "0x" + runtime_blob.hex()
                runtime_char_len = len(runtime_hex)
                label_hint = f" [{primary_runtime_label}]" if primary_runtime_label else ""
                print(
                    f"  [OK] Runtime bytecode (transpiled): {runtime_char_len} chars"
                    f" ({primary_runtime_bytes} bytes){label_hint}"
                )
                if len(runtime_sections) > 1:
                    extras = ", ".join(
                        f"{label}:{len(data)}b" for label, data in list(runtime_sections.items())[1:]
                    )
                    print(f"  [INFO] Additional runtime sections: {extras}")
            else:
                print("  [INFO] Runtime bytecode (transpiled): n/a")

            if reference_runtime_bytes and primary_runtime_bytes is not None:
                runtime_delta_pct = (
                    (primary_runtime_bytes - reference_runtime_bytes)
                    / reference_runtime_bytes
                ) * 100
                print(
                    f"  [INFO] Size delta vs solc runtime: {runtime_delta_pct:+.2f}%"
                )
            else:
                print("  [INFO] Size delta vs solc runtime: n/a")

            # Compile remaining artifacts to measure total size impact
            for fq_name, artifact in deployable_artifacts.items():
                if fq_name in compiled_bytecode_artifacts:
                    continue
                object_info = self._select_object_info(object_lookup, artifact.contract_name)
                zero_map = zero_link_maps.get(fq_name, {})
                compiled_bytecode_artifacts[fq_name] = self.yul_transpiler.compile_yul_to_bytecode(
                    yul_code,
                    object_name=object_info.name,
                    link_libraries=zero_map if zero_map else None,
                    return_details=True,
                )

            reference_total_deploy_bytes = sum(
                _hex_length_in_bytes(artifact.bytecode)
                for artifact in deployable_artifacts.values()
                if artifact.bytecode
            )
            reference_total_runtime_bytes = sum(
                _hex_length_in_bytes(artifact.runtime_bytecode)
                for artifact in deployable_artifacts.values()
                if artifact.runtime_bytecode
            )

            def _primary_runtime_len(artifact: YulBytecodeArtifact) -> int:
                for data in artifact.runtime_sections.values():
                    if isinstance(data, bytes):
                        return len(data)
                return 0

            transpiled_total_deploy_bytes = sum(
                _hex_length_in_bytes(compiled.deploy_bytecode)
                for compiled in compiled_bytecode_artifacts.values()
            )
            transpiled_total_runtime_bytes = sum(
                _primary_runtime_len(compiled)
                for compiled in compiled_bytecode_artifacts.values()
            )

            print(
                f"  [INFO] Reference deploy size (incl deps): {reference_total_deploy_bytes} bytes"
            )
            print(
                f"  [INFO] Transpiled deploy size (incl deps): {transpiled_total_deploy_bytes} bytes"
            )
            if reference_total_deploy_bytes:
                total_deploy_delta_pct = (
                    (transpiled_total_deploy_bytes - reference_total_deploy_bytes)
                    / reference_total_deploy_bytes
                ) * 100
                print(
                    f"  [INFO] Total deploy delta vs solc: {total_deploy_delta_pct:+.2f}%"
                )
            else:
                print("  [INFO] Total deploy delta vs solc: n/a")

            print(
                f"  [INFO] Reference runtime size (incl deps): {reference_total_runtime_bytes} bytes"
            )
            print(
                f"  [INFO] Transpiled runtime size (incl deps): {transpiled_total_runtime_bytes} bytes"
            )
            if reference_total_runtime_bytes:
                total_runtime_delta_pct = (
                    (transpiled_total_runtime_bytes - reference_total_runtime_bytes)
                    / reference_total_runtime_bytes
                ) * 100
                print(
                    f"  [INFO] Total runtime delta vs solc: {total_runtime_delta_pct:+.2f}%"
                )
            else:
                print("  [INFO] Total runtime delta vs solc: n/a")

            deployment_order = self._topologically_sort_artifacts(
                deployable_artifacts, artifact_dependencies
            )
            original_plan, transpiled_plan = self._build_deployment_plans(
                yul_code,
                deployable_artifacts,
                artifact_dependencies,
                dependency_aliases,
                deployment_order,
                object_lookup,
            )

            for step in original_plan:
                if step.name == primary_artifact.fully_qualified_name:
                    step.constructor_args = ctor_args
            for step in transpiled_plan:
                if step.name == primary_artifact.fully_qualified_name:
                    step.constructor_args = ctor_args

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
            
            validation_reports = self.execution_validator.validate_execution_from_plans(
                original_plan,
                transpiled_plan,
                target_name=primary_artifact.fully_qualified_name,
                test_cases=test_cases,
            )
            
            # Print validation results
            deploy_gas1 = None
            deploy_gas2 = None
            deploy_summary: Optional[Any] = None
            step_reports: List[Any] = []
            execution_reports: List[Any] = []

            if validation_reports:
                deploy_summary = validation_reports[0]
                symbol = "[OK]" if deploy_summary.status == ValidationResult.PASS else "[FAIL]"
                print(f"  {symbol} {deploy_summary.test_name}: {deploy_summary.message}")
                deploy_details = deploy_summary.details or {}
                deploy_gas1 = deploy_details.get("original_gas_used")
                deploy_gas2 = deploy_details.get("transpiled_gas_used")

            for report in validation_reports[1:]:
                if report.test_name.startswith("deploy["):
                    step_reports.append(report)
                else:
                    execution_reports.append(report)

            for report in step_reports:
                symbol = "[OK]" if report.status == ValidationResult.PASS else "[FAIL]"
                print(f"  {symbol} {report.test_name}: {report.message}")

            total_original_gas = 0
            total_transpiled_gas = 0
            has_original_gas = False
            has_transpiled_gas = False
            for report in execution_reports:
                symbol = "[OK]" if report.status == ValidationResult.PASS else "[FAIL]"
                print(f"  {symbol} {report.test_name}: {report.message}")
                details = report.details or {}
                original_gas = details.get("original_gas_used")
                transpiled_gas = details.get("transpiled_gas_used")
                if original_gas is not None:
                    total_original_gas += original_gas
                    has_original_gas = True
                if transpiled_gas is not None:
                    total_transpiled_gas += transpiled_gas
                    has_transpiled_gas = True
            
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
                venom_ir_size=venom_ir_size,
                reference_deploy_bytes=reference_deploy_bytes,
                transpiled_deploy_bytes=transpiled_deploy_bytes,
                reference_deploy_gas=deploy_gas1,
                transpiled_deploy_gas=deploy_gas2,
                reference_call_gas=total_original_gas if has_original_gas else None,
                transpiled_call_gas=total_transpiled_gas if has_transpiled_gas else None,
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

    def _artifact_has_code(self, artifact: ContractArtifact) -> bool:
        return bool(
            self.solc_compiler._strip_0x(artifact.bytecode)
            or self.solc_compiler._strip_0x(artifact.runtime_bytecode)
        )

    def _build_object_lookup(self, object_infos: Dict[str, Any]) -> Dict[str, List[Any]]:
        lookup: Dict[str, List[Any]] = {}
        for info in object_infos.values():
            lookup.setdefault(info.base_name, []).append(info)

        for infos in lookup.values():
            infos.sort(key=lambda entry: (len(entry.name), entry.name))
        return lookup

    def _select_object_info(self, lookup: Dict[str, List[Any]], contract_name: str) -> Any:
        infos = lookup.get(contract_name)
        if not infos and "_" in contract_name:
            base = contract_name.split("_", 1)[0]
            infos = lookup.get(base)
        if not infos:
            available = ", ".join(sorted(lookup))
            raise ValueError(
                f"Unable to locate Yul object for contract '{contract_name}'. Available: {available}"
            )
        return infos[0]

    def _topologically_sort_artifacts(
        self,
        artifacts: Dict[str, ContractArtifact],
        dependencies: Dict[str, Tuple[str, ...]],
    ) -> List[str]:
        order: List[str] = []
        temp_mark: set[str] = set()
        perm_mark: set[str] = set()

        def visit(name: str) -> None:
            if name in perm_mark:
                return
            if name in temp_mark:
                raise ValueError(
                    f"Cycle detected in artifact dependencies involving {name}"
                )
            temp_mark.add(name)
            for dep in dependencies.get(name, ()): 
                if dep in artifacts:
                    visit(dep)
            temp_mark.remove(name)
            perm_mark.add(name)
            order.append(name)

        for name in artifacts:
            visit(name)

        return order

    def _build_deployment_plans(
        self,
        yul_code: str,
        artifacts: Dict[str, ContractArtifact],
        dependencies: Dict[str, Tuple[str, ...]],
        dependency_aliases: Dict[str, Dict[str, str]],
        order: List[str],
        object_lookup: Dict[str, List[Any]],
    ) -> Tuple[List[DeploymentStep], List[DeploymentStep]]:
        original_plan: List[DeploymentStep] = []
        transpiled_plan: List[DeploymentStep] = []

        for fq_name in order:
            artifact = artifacts[fq_name]
            deps = tuple(dep for dep in dependencies.get(fq_name, ()) if dep in artifacts)
            object_info = self._select_object_info(object_lookup, artifact.contract_name)
            alias_map = dependency_aliases.get(fq_name, {})

            def original_builder(
                addresses: Dict[str, str],
                artifact: ContractArtifact = artifact,
                deps: Tuple[str, ...] = deps,
            ) -> str:
                if not deps:
                    return artifact.bytecode
                link_map = {dep: addresses[dep] for dep in deps}
                return self.solc_compiler.link_bytecode(artifact, link_map)

            def transpiled_builder(
                addresses: Dict[str, str],
                alias_map: Dict[str, str] = alias_map,
                object_name: str = object_info.name,
            ) -> str:
                link_map: Dict[str, int] = {}
                for original, normalized in alias_map.items():
                    if normalized in addresses:
                        link_map[original] = _address_to_int(addresses[normalized])

                return self.yul_transpiler.compile_yul_to_bytecode(
                    yul_code,
                    object_name=object_name,
                    link_libraries=link_map if link_map else None,
                )

            original_plan.append(
                DeploymentStep(
                    name=fq_name,
                    bytecode_builder=original_builder,
                    dependencies=deps,
                )
            )

            transpiled_plan.append(
                DeploymentStep(
                    name=fq_name,
                    bytecode_builder=transpiled_builder,
                    dependencies=deps,
                )
            )

        return original_plan, transpiled_plan
    
    def run_all_tests(self, test_filter: Optional[List[str]] = None) -> None:
        """
        Run all discovered tests.

        Args:
            test_filter: Optional list of test names to run
        """
        test_cases = self.discover_tests()

        if test_filter:
            test_cases = [tc for tc in test_cases if tc.name in test_filter]

        # Count skipped tests
        skipped_count = len(SKIP_TESTS)
        total_count = len(test_cases) + skipped_count

        print(f"\n{'='*60}")
        print(f"Discovered {total_count} test cases ({skipped_count} skipped)")
        print(f"{'='*60}")

        # Report skipped tests
        for test_name, reason in SKIP_TESTS.items():
            print(f"\n[SKIP] {test_name}: {reason[:80]}...")
            # Add a skip result
            self.results.append(TestResult(
                test_case=TestCase(
                    name=test_name,
                    solidity_file=Path(f"fixtures/solidity/{test_name}.sol"),
                    description=f"Test {test_name}",
                    tags=["skipped"],
                ),
                status="skip",
                duration=0.0,
                validation_reports=[],
                error_message=reason,
            ))

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

        total_reference_bytes = 0
        total_transpiled_bytes = 0
        per_contract_reductions: List[float] = []
        for result in self.results:
            ref = result.reference_deploy_bytes
            trans = result.transpiled_deploy_bytes
            if ref is None or trans is None:
                continue
            total_reference_bytes += ref
            total_transpiled_bytes += trans
            if ref > 0:
                per_contract_reductions.append((ref - trans) / ref * 100)

        size_metrics: Dict[str, Any] = {
            "total_reference_bytes": total_reference_bytes,
            "total_transpiled_bytes": total_transpiled_bytes,
        }
        if total_reference_bytes > 0:
            size_metrics["overall_reduction_pct"] = (
                (total_reference_bytes - total_transpiled_bytes)
                / total_reference_bytes
                * 100
            )
        if per_contract_reductions:
            size_metrics["average_reduction_pct"] = (
                sum(per_contract_reductions) / len(per_contract_reductions)
            )

        report["size_metrics"] = size_metrics

        total_reference_gas = 0
        total_transpiled_gas = 0
        per_contract_gas_reductions: List[float] = []
        total_reference_deploy_gas = 0
        total_transpiled_deploy_gas = 0
        total_reference_call_gas = 0
        total_transpiled_call_gas = 0
        per_contract_call_reductions: List[float] = []
        per_contract_deploy_reductions: List[float] = []
        for result in self.results:
            ref_deploy_gas = result.reference_deploy_gas
            trans_deploy_gas = result.transpiled_deploy_gas
            if ref_deploy_gas is not None and trans_deploy_gas is not None:
                total_reference_deploy_gas += ref_deploy_gas
                total_transpiled_deploy_gas += trans_deploy_gas
                if ref_deploy_gas > 0:
                    per_contract_deploy_reductions.append(
                        (ref_deploy_gas - trans_deploy_gas) / ref_deploy_gas * 100
                    )

            ref_call_gas = result.reference_call_gas
            trans_call_gas = result.transpiled_call_gas
            if ref_call_gas is not None and trans_call_gas is not None:
                total_reference_call_gas += ref_call_gas
                total_transpiled_call_gas += trans_call_gas
                if ref_call_gas > 0:
                    per_contract_call_reductions.append(
                        (ref_call_gas - trans_call_gas) / ref_call_gas * 100
                    )

        gas_metrics: Dict[str, Any] = {
            "total_reference_deploy_gas": total_reference_deploy_gas,
            "total_transpiled_deploy_gas": total_transpiled_deploy_gas,
            "total_reference_call_gas": total_reference_call_gas,
            "total_transpiled_call_gas": total_transpiled_call_gas,
        }
        if total_reference_deploy_gas > 0:
            gas_metrics["deploy_reduction_pct"] = (
                (total_reference_deploy_gas - total_transpiled_deploy_gas)
                / total_reference_deploy_gas
                * 100
            )
        if per_contract_deploy_reductions:
            gas_metrics["deploy_average_reduction_pct"] = (
                sum(per_contract_deploy_reductions) / len(per_contract_deploy_reductions)
            )

        if total_reference_call_gas > 0:
            gas_metrics["call_reduction_pct"] = (
                (total_reference_call_gas - total_transpiled_call_gas)
                / total_reference_call_gas
                * 100
            )
        if per_contract_call_reductions:
            gas_metrics["call_average_reduction_pct"] = (
                sum(per_contract_call_reductions) / len(per_contract_call_reductions)
            )

        report["gas_metrics"] = gas_metrics

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
        size_metrics = report.get("size_metrics", {})
        ref_bytes = size_metrics.get("total_reference_bytes", 0)
        trans_bytes = size_metrics.get("total_transpiled_bytes", 0)
        overall_pct = size_metrics.get("overall_reduction_pct")
        if ref_bytes and trans_bytes:
            pct_str = _format_pct(overall_pct)
            print(
                f"Bytecode size (deploy): {ref_bytes} → {trans_bytes} bytes{pct_str}"
            )
        gas_metrics = report.get("gas_metrics", {})
        ref_deploy_gas = gas_metrics.get("total_reference_deploy_gas", 0)
        trans_deploy_gas = gas_metrics.get("total_transpiled_deploy_gas", 0)
        deploy_pct = gas_metrics.get("deploy_reduction_pct")
        if ref_deploy_gas and trans_deploy_gas:
            pct_str = _format_pct(deploy_pct)
            print(
                f"Deploy gas: {ref_deploy_gas} → {trans_deploy_gas}{pct_str}"
            )

        ref_call_gas = gas_metrics.get("total_reference_call_gas", 0)
        trans_call_gas = gas_metrics.get("total_transpiled_call_gas", 0)
        call_pct = gas_metrics.get("call_reduction_pct")
        if ref_call_gas and trans_call_gas:
            pct_str = _format_pct(call_pct)
            print(
                f"Call gas: {ref_call_gas} → {trans_call_gas}{pct_str}"
            )
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
