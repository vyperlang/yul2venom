#!/usr/bin/env python3
"""
Solc compiler wrapper for compiling Solidity contracts to Yul
"""

from __future__ import annotations

import json
import subprocess
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Dict, List, Mapping, Optional, Tuple


@dataclass(frozen=True)
class ContractArtifact:
    """Container for per-contract compilation outputs from solc."""

    fully_qualified_name: str
    contract_name: str
    source_path: str
    bytecode: str
    runtime_bytecode: str
    link_references: Dict[str, List[Tuple[int, int]]]
    abi: Optional[List[Dict[str, Any]]] = None

    @property
    def dependencies(self) -> List[str]:
        return sorted(self.link_references)


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
        artifacts = self.compile_contract_artifacts(solidity_file, optimize=optimize)

        if not artifacts:
            return "", ""

        target_name = solidity_file.stem.lower()
        preferred: Optional[ContractArtifact] = None
        fallback: Optional[ContractArtifact] = None

        for artifact in artifacts.values():
            name_match = artifact.contract_name == solidity_file.stem
            case_insensitive_match = artifact.contract_name.lower() == target_name
            has_code = bool(self._strip_0x(artifact.bytecode) or self._strip_0x(artifact.runtime_bytecode))

            if not has_code:
                continue

            if name_match:
                preferred = artifact
                break

            if case_insensitive_match and fallback is None:
                fallback = artifact

            if fallback is None:
                fallback = artifact

        selected = preferred or fallback
        if selected is None:
            return "", ""

        return selected.bytecode, selected.runtime_bytecode

    def compile_contract_artifacts(
        self, solidity_file: Path, optimize: bool = False
    ) -> Dict[str, ContractArtifact]:
        """Returns a mapping keyed by fully-qualified contract name in the form
        ``<filename>:<contract>``.
        """

        if not solidity_file.exists():
            raise FileNotFoundError(f"Solidity file not found: {solidity_file}")

        solc_json = self.compile_to_json(solidity_file, optimize=optimize)
        contracts = solc_json.get("contracts", {}).get(solidity_file.name, {})

        artifacts: Dict[str, ContractArtifact] = {}
        for name, entry in contracts.items():
            fq_name = f"{solidity_file.name}:{name}"
            evm: Dict[str, Any] = entry.get("evm", {}) if entry else {}
            bytecode_info: Dict[str, Any] = evm.get("bytecode", {}) if evm else {}
            runtime_info: Dict[str, Any] = evm.get("deployedBytecode", {}) if evm else {}

            bytecode_obj = bytecode_info.get("object") or ""
            runtime_obj = runtime_info.get("object") or ""

            link_refs = self._parse_link_references(bytecode_info.get("linkReferences", {}))

            artifacts[fq_name] = ContractArtifact(
                fully_qualified_name=fq_name,
                contract_name=name,
                source_path=solidity_file.name,
                bytecode=self._ensure_hex_prefix(bytecode_obj),
                runtime_bytecode=self._ensure_hex_prefix(runtime_obj),
                link_references=link_refs,
                abi=entry.get("abi"),
            )

        return artifacts
    
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

    @staticmethod
    def _ensure_hex_prefix(value: str) -> str:
        value = value or ""
        return value if not value or value.startswith("0x") else f"0x{value}"

    @staticmethod
    def _strip_0x(value: str) -> str:
        return value[2:] if value.startswith("0x") else value

    @staticmethod
    def _parse_link_references(raw: Mapping[str, Mapping[str, List[Dict[str, int]]]]) -> Dict[str, List[Tuple[int, int]]]:
        link_refs: Dict[str, List[Tuple[int, int]]] = {}
        for file_path, contracts in (raw or {}).items():
            for contract_name, positions in contracts.items():
                fq_name = f"{file_path}:{contract_name}"
                link_refs.setdefault(fq_name, [])
                for position in positions:
                    start = position.get("start")
                    length = position.get("length")
                    if start is None or length is None:
                        continue
                    link_refs[fq_name].append((start, length))

        return link_refs

    def link_bytecode(
        self,
        artifact: ContractArtifact,
        library_addresses: Mapping[str, str],
    ) -> str:
        """Link a contract's creation bytecode using deployed library addresses."""

        if not artifact.link_references:
            return artifact.bytecode

        bytecode = self._strip_0x(artifact.bytecode)
        if not bytecode:
            return artifact.bytecode

        bytecode_chars = list(bytecode)

        for reference, positions in artifact.link_references.items():
            if reference not in library_addresses:
                raise ValueError(
                    f"Missing address for library '{reference}' required by {artifact.fully_qualified_name}"
                )

            address_hex = self._strip_0x(library_addresses[reference]).lower()
            expected_length = positions[0][1] if positions else 20

            if len(address_hex) > expected_length * 2:
                raise ValueError(
                    f"Address {library_addresses[reference]} is too long for reference '{reference}'"
                )

            address_hex = address_hex.rjust(expected_length * 2, "0")

            for start, length in sorted(positions):
                start_index = start * 2
                end_index = start_index + length * 2
                bytecode_chars[start_index:end_index] = list(address_hex)

        linked = "".join(bytecode_chars)
        return self._ensure_hex_prefix(linked)


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
