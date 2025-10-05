#!/usr/bin/env python3
"""
Solc compiler wrapper for compiling Solidity contracts to Yul.
"""

import json
import subprocess
import tempfile
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple


class SolcCompiler:
    """Wrapper for solc to compile Solidity contracts to Yul."""
    
    def __init__(self, solc_path: str = "solc"):
        """
        Initialize the SolcCompiler.
        
        Args:
            solc_path: Path to solc binary (default: "solc" in PATH)
        """
        self.solc_path = solc_path
        self._verify_solc()
    
    def _verify_solc(self):
        """Verify that solc is available and get version."""
        try:
            result = subprocess.run(
                [self.solc_path, "--version"],
                capture_output=True,
                text=True,
                check=True
            )
            # Parse version from output
            for line in result.stdout.split('\n'):
                if 'Version:' in line:
                    self.version = line.split('Version:')[1].strip()
                    break
        except (subprocess.CalledProcessError, FileNotFoundError) as e:
            raise RuntimeError(f"solc not found or not executable: {e}")
    
    def compile_to_yul(self, solidity_file: Path, optimize: bool = False) -> str:
        """
        Compile a Solidity file to Yul IR.

        Args:
            solidity_file: Path to the Solidity source file
            optimize: Whether to enable optimizer

        Returns:
            Yul IR code as string
        """
        if not solidity_file.exists():
            raise FileNotFoundError(f"Solidity file not found: {solidity_file}")

        cmd = [
            self.solc_path,
            "--ir-optimized" if optimize else "--ir",
            "--via-ir",  # Use IR pipeline to avoid stack too deep errors
            "--no-color",
            str(solidity_file)
        ]

        if optimize:
            cmd.extend(["--optimize", "--optimize-runs", "200"])
        
        try:
            result = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                check=True
            )
            
            # Extract Yul code from output
            # solc outputs the Yul after the IR/Optimized IR markers
            yul_code = self._extract_yul_from_output(result.stdout)
            return yul_code
            
        except subprocess.CalledProcessError as e:
            raise RuntimeError(f"Compilation failed: {e.stderr}")
    
    def compile_to_bytecode(self, solidity_file: Path, optimize: bool = False) -> Tuple[str, str]:
        """
        Compile a Solidity file to bytecode (for comparison).
        
        Args:
            solidity_file: Path to the Solidity source file
            optimize: Whether to enable optimizer
        
        Returns:
            Tuple of (deployment_bytecode, runtime_bytecode)
        """
        if not solidity_file.exists():
            raise FileNotFoundError(f"Solidity file not found: {solidity_file}")
        
        # Get contract name from file
        contract_name = solidity_file.stem
        
        solc_json = self.compile_to_json(solidity_file, optimize=optimize)
        contracts = solc_json.get("contracts", {}).get(solidity_file.name, {})

        def _extract_bytecode(entry: Dict[str, Any]) -> Tuple[str, str]:
            evm = entry.get("evm", {}) if entry else {}
            bytecode = evm.get("bytecode", {}).get("object") or ""
            runtime = evm.get("deployedBytecode", {}).get("object") or ""
            return bytecode, runtime

        candidates: List[Tuple[str, str, str]] = []
        for name, entry in contracts.items():
            bytecode, runtime = _extract_bytecode(entry)
            candidates.append((name, bytecode, runtime))

        # Filter to contracts with actual bytecode to avoid abstract/interfaces.
        non_empty = [item for item in candidates if item[1] or item[2]]
        if not non_empty:
            return "", ""

        # Prefer a contract whose name matches the file stem (case-insensitive).
        target = solidity_file.stem.lower()
        for name, bytecode, runtime in non_empty:
            if name == solidity_file.stem and (bytecode or runtime):
                return bytecode, runtime
        for name, bytecode, runtime in non_empty:
            if name.lower() == target:
                return bytecode, runtime

        # Fall back to the contract with the largest deployed bytecode (or creation).
        name, bytecode, runtime = max(
            non_empty,
            key=lambda item: max(len(item[2]), len(item[1]))
        )
        return bytecode, runtime
    
    def compile_to_json(self, solidity_file: Path, optimize: bool = False) -> Dict:
        """
        Compile a Solidity file and get full JSON output.
        
        Args:
            solidity_file: Path to the Solidity source file
            optimize: Whether to enable optimizer
        
        Returns:
            JSON output from solc
        """
        if not solidity_file.exists():
            raise FileNotFoundError(f"Solidity file not found: {solidity_file}")
        
        # Prepare standard JSON input
        with open(solidity_file, 'r') as f:
            source_code = f.read()
        
        json_input = {
            "language": "Solidity",
            "sources": {
                str(solidity_file.name): {
                    "content": source_code
                }
            },
            "settings": {
                "viaIR": True,  # Use IR pipeline to avoid stack too deep errors
                "optimizer": {
                    "enabled": optimize,
                    "runs": 200
                },
                "outputSelection": {
                    "*": {
                        "*": [
                            "abi",
                            "evm.bytecode",
                            "evm.deployedBytecode",
                            "evm.methodIdentifiers",
                            "ir",
                            "irOptimized"
                        ]
                    }
                }
            }
        }
        
        try:
            result = subprocess.run(
                [self.solc_path, "--standard-json"],
                input=json.dumps(json_input),
                capture_output=True,
                text=True,
                check=True
            )
            
            return json.loads(result.stdout)
            
        except subprocess.CalledProcessError as e:
            raise RuntimeError(f"Compilation failed: {e.stderr}")
    
    def _extract_yul_from_output(self, output: str) -> str:
        """Extract one or more Yul sections from solc text output."""
        lines = output.splitlines()

        def flush_section(buffer: List[str], sections: List[str]) -> None:
            if buffer and any(entry.strip() for entry in buffer):
                sections.append("\n".join(buffer))
            buffer.clear()

        sections: List[str] = []
        current_section: List[str] = []
        capturing = False

        start_markers = ("Optimized IR:", "IR:")
        stop_markers = ("Binary:", "Binary of the runtime part:", "=======")

        for line in lines:
            stripped = line.strip()

            if stripped.startswith(start_markers):
                flush_section(current_section, sections)
                capturing = True
                continue

            if capturing and stripped.startswith(stop_markers):
                flush_section(current_section, sections)
                capturing = False
                continue

            if capturing:
                current_section.append(line)

        flush_section(current_section, sections)

        return "\n\n".join(sections)
    
    def get_version(self) -> str:
        """Get the solc version."""
        return self.version


def main():
    """Test the compiler wrapper."""
    import sys
    
    if len(sys.argv) < 2:
        print("Usage: python solc_compiler.py <solidity_file>")
        sys.exit(1)
    
    compiler = SolcCompiler()
    print(f"Using solc version: {compiler.get_version()}")
    
    sol_file = Path(sys.argv[1])
    
    # Compile to Yul
    print("\n=== Compiling to Yul ===")
    yul_code = compiler.compile_to_yul(sol_file)
    print(yul_code[:500] + "..." if len(yul_code) > 500 else yul_code)
    
    # Compile to bytecode
    print("\n=== Compiling to bytecode ===")
    deploy_code, runtime_code = compiler.compile_to_bytecode(sol_file)
    print(f"Deployment bytecode: {deploy_code[:100]}...")
    print(f"Runtime bytecode: {runtime_code[:100]}...")


if __name__ == "__main__":
    main()
