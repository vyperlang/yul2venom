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

from test_validation.utils.hex_utils import strip_0x


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
        self.version = "unknown"
        try:
            result = subprocess.run(
                [self.solc_path, "--version"],
                capture_output=True,
                text=True,
                check=True,
                timeout=300,
            )
            # Parse version from output
            for line in result.stdout.split('\n'):
                if 'Version:' in line:
                    self.version = line.split('Version:')[1].strip()
                    break
        except (subprocess.CalledProcessError, FileNotFoundError) as e:
            raise RuntimeError(f"solc not found or not executable: {e}")
    
    def compile_to_yul(
        self,
        solidity_file: Path,
        optimize: bool = False,
        base_path: Optional[Path] = None,
        include_paths: Optional[List[Path]] = None,
        remappings: Optional[List[str]] = None,
    ) -> str:
        """
        Compile a Solidity file to Yul IR.

        Args:
            solidity_file: Path to the Solidity source file
            optimize: Whether to enable optimizer
            base_path: Root directory for import resolution
            include_paths: Additional directories to search for imports
            remappings: Import path remappings (e.g., "@openzeppelin/=lib/openzeppelin/")

        Returns:
            Yul IR code as string
        """
        if not solidity_file.exists():
            raise FileNotFoundError(f"Solidity file not found: {solidity_file}")

        solidity_file = solidity_file.resolve()

        cmd = [
            self.solc_path,
            "--ir-optimized" if optimize else "--ir",
            "--via-ir",
            "--no-color",
        ]

        if optimize:
            cmd.extend(["--optimize", "--optimize-runs", "200"])

        # Import resolution options
        if base_path:
            cmd.extend(["--base-path", str(base_path.resolve())])
            cmd.extend(["--allow-paths", str(base_path.resolve())])

        if include_paths:
            for inc_path in include_paths:
                cmd.extend(["--include-path", str(inc_path.resolve())])

        if remappings:
            for remap in remappings:
                cmd.append(remap)

        cmd.append(str(solidity_file))

        try:
            result = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                check=True,
                cwd=str(base_path.resolve()) if base_path else None,
                timeout=300,
            )

            yul_code = self._extract_yul_from_output(result.stdout)
            return yul_code

        except subprocess.CalledProcessError as e:
            raise RuntimeError(f"Compilation failed: {e.stderr}")
    
    def compile_to_bytecode(
        self,
        solidity_file: Path,
        optimize: bool = False,
        base_path: Optional[Path] = None,
        include_paths: Optional[List[Path]] = None,
        remappings: Optional[List[str]] = None,
    ) -> Tuple[str, str]:
        artifacts = self.compile_contract_artifacts(
            solidity_file,
            optimize=optimize,
            base_path=base_path,
            include_paths=include_paths,
            remappings=remappings,
        )

        selected = self.select_primary_artifact(solidity_file, artifacts)
        if selected is None:
            return "", ""

        return selected.bytecode, selected.runtime_bytecode

    def compile_contract_artifacts(
        self,
        solidity_file: Path,
        optimize: bool = False,
        base_path: Optional[Path] = None,
        include_paths: Optional[List[Path]] = None,
        remappings: Optional[List[str]] = None,
    ) -> Dict[str, ContractArtifact]:
        """Returns a mapping keyed by fully-qualified contract name in the form
        ``<filename>:<contract>``.
        """

        if not solidity_file.exists():
            raise FileNotFoundError(f"Solidity file not found: {solidity_file}")

        solidity_file = solidity_file.resolve()

        # Compute source key matching compile_to_json
        if base_path:
            try:
                source_key = str(solidity_file.relative_to(base_path.resolve()))
            except ValueError:
                source_key = solidity_file.name
        else:
            source_key = solidity_file.name

        solc_json = self.compile_to_json(
            solidity_file,
            optimize=optimize,
            base_path=base_path,
            include_paths=include_paths,
            remappings=remappings,
        )
        contracts = solc_json.get("contracts", {}).get(source_key, {})

        artifacts: Dict[str, ContractArtifact] = {}
        for name, entry in contracts.items():
            fq_name = f"{source_key}:{name}"
            evm: Dict[str, Any] = entry.get("evm", {}) if entry else {}
            bytecode_info: Dict[str, Any] = evm.get("bytecode", {}) if evm else {}
            runtime_info: Dict[str, Any] = evm.get("deployedBytecode", {}) if evm else {}

            bytecode_obj = bytecode_info.get("object") or ""
            runtime_obj = runtime_info.get("object") or ""

            link_refs = self._parse_link_references(bytecode_info.get("linkReferences", {}))

            artifacts[fq_name] = ContractArtifact(
                fully_qualified_name=fq_name,
                contract_name=name,
                source_path=source_key,
                bytecode=self._ensure_hex_prefix(bytecode_obj),
                runtime_bytecode=self._ensure_hex_prefix(runtime_obj),
                link_references=link_refs,
                abi=entry.get("abi"),
            )

        return artifacts

    def select_primary_artifact(
        self,
        solidity_file: Path,
        artifacts: Mapping[str, ContractArtifact],
    ) -> Optional[ContractArtifact]:
        if not artifacts:
            return None

        target_stem = solidity_file.stem
        target_lower = target_stem.lower()

        def _has_code(artifact: ContractArtifact) -> bool:
            return bool(
                strip_0x(artifact.bytecode)
                or strip_0x(artifact.runtime_bytecode)
            )

        non_empty = [artifact for artifact in artifacts.values() if _has_code(artifact)]
        if not non_empty:
            return None

        for artifact in non_empty:
            if artifact.contract_name == target_stem:
                return artifact

        for artifact in non_empty:
            if artifact.contract_name.lower() == target_lower:
                return artifact

        return max(
            non_empty,
            key=lambda art: max(
                len(strip_0x(art.runtime_bytecode)),
                len(strip_0x(art.bytecode)),
            ),
        )
    
    def compile_to_json(
        self,
        solidity_file: Path,
        optimize: bool = False,
        base_path: Optional[Path] = None,
        include_paths: Optional[List[Path]] = None,
        remappings: Optional[List[str]] = None,
    ) -> Dict:
        """
        Compile a Solidity file and get full JSON output.

        Args:
            solidity_file: Path to the Solidity source file
            optimize: Whether to enable optimizer
            base_path: Root directory for import resolution
            include_paths: Additional directories to search for imports
            remappings: Import path remappings (e.g., "@openzeppelin/=lib/openzeppelin/")

        Returns:
            JSON output from solc
        """
        if not solidity_file.exists():
            raise FileNotFoundError(f"Solidity file not found: {solidity_file}")

        solidity_file = solidity_file.resolve()

        # Read source content
        with open(solidity_file, "r") as f:
            source_code = f.read()

        # Compute source key - use relative path from base_path for proper import resolution
        if base_path:
            try:
                source_key = str(solidity_file.relative_to(base_path.resolve()))
            except ValueError:
                source_key = solidity_file.name
        else:
            source_key = solidity_file.name

        json_input: Dict[str, Any] = {
            "language": "Solidity",
            "sources": {
                source_key: {
                    "content": source_code
                }
            },
            "settings": {
                "viaIR": True,
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

        if remappings:
            json_input["settings"]["remappings"] = remappings

        # Build command with import resolution flags
        cmd = [self.solc_path, "--standard-json"]

        if base_path:
            cmd.extend(["--base-path", str(base_path.resolve())])
            cmd.extend(["--allow-paths", str(base_path.resolve()) + "," + str(solidity_file.parent)])

        if include_paths:
            for inc_path in include_paths:
                cmd.extend(["--include-path", str(inc_path.resolve())])

        # Run solc from the base_path directory if specified
        cwd = str(base_path.resolve()) if base_path else str(solidity_file.parent)

        try:
            result = subprocess.run(
                cmd,
                input=json.dumps(json_input),
                capture_output=True,
                text=True,
                check=True,
                cwd=cwd,
                timeout=300,
            )

            output = json.loads(result.stdout)

            # Check for errors in the output
            if "errors" in output:
                errors = [e for e in output["errors"] if e.get("severity") == "error"]
                if errors:
                    error_msgs = "\n".join(e.get("formattedMessage", e.get("message", "Unknown error")) for e in errors)
                    raise RuntimeError(f"Compilation errors:\n{error_msgs}")

            return output

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

        bytecode = strip_0x(artifact.bytecode)
        if not bytecode:
            return artifact.bytecode

        bytecode_chars = list(bytecode)

        for reference, positions in artifact.link_references.items():
            if reference not in library_addresses:
                raise ValueError(
                    f"Missing address for library '{reference}' required by {artifact.fully_qualified_name}"
                )

            address_hex = strip_0x(library_addresses[reference]).lower()
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
