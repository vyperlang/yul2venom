#!/usr/bin/env python3
"""
SolVenom - End-to-end Solidity to EVM bytecode compiler via Venom IR.

This tool compiles Solidity source files to EVM bytecode by:
1. Compiling Solidity to Yul IR via solc
2. Transpiling Yul to Venom IR
3. Generating EVM bytecode from Venom IR

Usage:
    python -m yul_to_venom.cli.solvenom <solidity_file> [options]
"""

from __future__ import annotations

import argparse
import json
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List, Mapping, Optional, Tuple

# Add parent paths for imports
_this_file = Path(__file__).resolve()
_repo_root = _this_file.parents[2]
sys.path.insert(0, str(_repo_root))

from test_validation.runners.solc_compiler import ContractArtifact, SolcCompiler
from test_validation.runners.yul_transpiler import YulTranspiler
from test_validation.utils.hex_utils import strip_0x


@dataclass
class CompilationResult:
    """Result of compiling a single contract."""
    contract_name: str
    fully_qualified_name: str
    deploy_bytecode: str
    runtime_bytecode: Optional[str]
    abi: Optional[List[Dict]]
    venom_ir: Optional[str]
    assembly: Optional[str]


@dataclass
class MultiContractResult:
    """Result of compiling a Solidity file with multiple contracts."""
    contracts: Dict[str, CompilationResult]
    primary_contract: Optional[str]
    warnings: List[str]


class SolVenomCompiler:
    """End-to-end Solidity to bytecode compiler via Venom IR."""

    def __init__(
        self,
        solc_path: str = "solc",
        vyper_path: Optional[str] = None,
        evm_version: str = "cancun",
    ):
        self.solc = SolcCompiler(solc_path=solc_path)
        self.transpiler = YulTranspiler(vyper_path=vyper_path)
        self.evm_version = evm_version

    def compile(
        self,
        solidity_file: Path,
        contract_name: Optional[str] = None,
        optimize: bool = True,
        output_venom: bool = False,
        output_asm: bool = False,
        library_addresses: Optional[Mapping[str, str]] = None,
        base_path: Optional[Path] = None,
        include_paths: Optional[List[Path]] = None,
        remappings: Optional[List[str]] = None,
    ) -> CompilationResult:
        """
        Compile a single contract from a Solidity file.

        Args:
            solidity_file: Path to Solidity source
            contract_name: Specific contract to compile (auto-selects if None)
            optimize: Enable optimizations
            output_venom: Include Venom IR in result
            output_asm: Include assembly in result
            library_addresses: Mapping of library names to deployed addresses
            base_path: Root directory for import resolution
            include_paths: Additional directories to search for imports
            remappings: Import path remappings

        Returns:
            CompilationResult with bytecode and optional IR/assembly
        """
        # Step 1: Get contract artifacts from solc
        artifacts = self.solc.compile_contract_artifacts(
            solidity_file,
            optimize=optimize,
            base_path=base_path,
            include_paths=include_paths,
            remappings=remappings,
        )

        if not artifacts:
            raise ValueError(f"No contracts found in {solidity_file}")

        # Select contract
        if contract_name:
            # Find by name (with or without file prefix)
            selected = None
            for fq_name, artifact in artifacts.items():
                if artifact.contract_name == contract_name or fq_name == contract_name:
                    selected = artifact
                    break
            if not selected:
                available = ", ".join(a.contract_name for a in artifacts.values())
                raise ValueError(f"Contract '{contract_name}' not found. Available: {available}")
        else:
            selected = self.solc.select_primary_artifact(solidity_file, artifacts)
            if not selected:
                raise ValueError("No deployable contracts found (all have empty bytecode)")

        # Step 2: Get Yul IR
        yul_code = self.solc.compile_to_yul(
            solidity_file,
            optimize=optimize,
            base_path=base_path,
            include_paths=include_paths,
            remappings=remappings,
        )

        # Step 3: Prepare link libraries
        link_libs = self._prepare_link_libraries(selected, library_addresses)

        # Step 4: Compile via Venom
        try:
            deploy_bytecode = self.transpiler.compile_yul_to_bytecode(
                yul_code,
                evm_version=self.evm_version,
                optimize=optimize,
                object_name=selected.contract_name,
                link_libraries=link_libs,
            )
        except Exception as e:
            raise RuntimeError(f"Venom compilation failed: {e}") from e

        # Optional outputs
        venom_ir = None
        assembly = None

        if output_venom:
            venom_ir = self.transpiler.compile_yul_to_venom_ir(
                yul_code,
                evm_version=self.evm_version,
                object_name=selected.contract_name,
                link_libraries=link_libs,
            )

        if output_asm:
            assembly = self.transpiler.compile_yul_to_assembly(
                yul_code,
                evm_version=self.evm_version,
                optimize=optimize,
                object_name=selected.contract_name,
                link_libraries=link_libs,
            )

        return CompilationResult(
            contract_name=selected.contract_name,
            fully_qualified_name=selected.fully_qualified_name,
            deploy_bytecode=deploy_bytecode,
            runtime_bytecode=None,  # Could extract from artifact if needed
            abi=selected.abi,
            venom_ir=venom_ir,
            assembly=assembly,
        )

    def compile_all(
        self,
        solidity_file: Path,
        optimize: bool = True,
        output_venom: bool = False,
        output_asm: bool = False,
        library_addresses: Optional[Mapping[str, str]] = None,
        base_path: Optional[Path] = None,
        include_paths: Optional[List[Path]] = None,
        remappings: Optional[List[str]] = None,
    ) -> MultiContractResult:
        """
        Compile all contracts from a Solidity file.

        Args:
            solidity_file: Path to Solidity source
            optimize: Enable optimizations
            output_venom: Include Venom IR in results
            output_asm: Include assembly in results
            library_addresses: Mapping of library names to deployed addresses
            base_path: Root directory for import resolution
            include_paths: Additional directories to search for imports
            remappings: Import path remappings

        Returns:
            MultiContractResult with all compiled contracts
        """
        artifacts = self.solc.compile_contract_artifacts(
            solidity_file,
            optimize=optimize,
            base_path=base_path,
            include_paths=include_paths,
            remappings=remappings,
        )
        yul_code = self.solc.compile_to_yul(
            solidity_file,
            optimize=optimize,
            base_path=base_path,
            include_paths=include_paths,
            remappings=remappings,
        )

        results: Dict[str, CompilationResult] = {}
        warnings: List[str] = []

        for fq_name, artifact in artifacts.items():
            # Skip contracts with no bytecode (interfaces, abstract contracts)
            if not strip_0x(artifact.bytecode) and not strip_0x(artifact.runtime_bytecode):
                continue

            link_libs = self._prepare_link_libraries(artifact, library_addresses)

            try:
                deploy_bytecode = self.transpiler.compile_yul_to_bytecode(
                    yul_code,
                    evm_version=self.evm_version,
                    optimize=optimize,
                    object_name=artifact.contract_name,
                    link_libraries=link_libs,
                )

                venom_ir = None
                assembly = None

                if output_venom:
                    venom_ir = self.transpiler.compile_yul_to_venom_ir(
                        yul_code,
                        evm_version=self.evm_version,
                        object_name=artifact.contract_name,
                        link_libraries=link_libs,
                    )

                if output_asm:
                    assembly = self.transpiler.compile_yul_to_assembly(
                        yul_code,
                        evm_version=self.evm_version,
                        optimize=optimize,
                        object_name=artifact.contract_name,
                        link_libraries=link_libs,
                    )

                results[artifact.contract_name] = CompilationResult(
                    contract_name=artifact.contract_name,
                    fully_qualified_name=fq_name,
                    deploy_bytecode=deploy_bytecode,
                    runtime_bytecode=None,
                    abi=artifact.abi,
                    venom_ir=venom_ir,
                    assembly=assembly,
                )

            except Exception as e:
                warnings.append(f"{artifact.contract_name}: {e}")

        primary = self.solc.select_primary_artifact(solidity_file, artifacts)
        primary_name = primary.contract_name if primary else None

        return MultiContractResult(
            contracts=results,
            primary_contract=primary_name,
            warnings=warnings,
        )

    def _prepare_link_libraries(
        self,
        artifact: ContractArtifact,
        library_addresses: Optional[Mapping[str, str]],
    ) -> Dict[str, int]:
        """Prepare library addresses for linking."""
        if not artifact.link_references:
            return {}

        lib_addresses = dict(library_addresses or {})
        result: Dict[str, int] = {}

        for ref in artifact.link_references:
            # Check if we have an address for this reference
            address = None

            # Try exact match
            if ref in lib_addresses:
                address = lib_addresses[ref]
            else:
                # Try by contract name only
                lib_name = ref.split(":")[-1] if ":" in ref else ref
                if lib_name in lib_addresses:
                    address = lib_addresses[lib_name]

            if address is not None:
                # Convert to int
                if isinstance(address, str):
                    addr_str = address.strip()
                    if addr_str.startswith("0x"):
                        addr_str = addr_str[2:]
                    result[ref] = int(addr_str, 16)
                else:
                    result[ref] = int(address)

        return result


def _parse_library_arg(value: str) -> Tuple[str, str]:
    """Parse --library argument in format 'name=address'."""
    if "=" not in value:
        raise argparse.ArgumentTypeError(
            f"Invalid library format '{value}'. Expected 'name=address'"
        )
    name, address = value.split("=", 1)
    return name.strip(), address.strip()


def main():
    parser = argparse.ArgumentParser(
        prog="solvenom",
        description="SolVenom - Solidity to EVM bytecode compiler via Venom IR",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s MyContract.sol                    # Compile primary contract
  %(prog)s MyContract.sol --contract Token   # Compile specific contract
  %(prog)s MyContract.sol --venom            # Output Venom IR
  %(prog)s MyContract.sol --asm              # Output assembly
  %(prog)s MyContract.sol --json             # JSON output with all info
  %(prog)s MyContract.sol --all              # Compile all contracts
  %(prog)s MyContract.sol --library Math=0x1234...  # Link library
        """,
    )

    parser.add_argument(
        "solidity_file",
        type=Path,
        help="Path to Solidity source file",
    )

    parser.add_argument(
        "--contract", "-c",
        type=str,
        default=None,
        help="Contract name to compile (auto-selects if not specified)",
    )

    parser.add_argument(
        "--all", "-a",
        action="store_true",
        help="Compile all contracts in the file",
    )

    output_group = parser.add_mutually_exclusive_group()
    output_group.add_argument(
        "--venom",
        action="store_true",
        help="Output Venom IR instead of bytecode",
    )
    output_group.add_argument(
        "--asm",
        action="store_true",
        help="Output assembly instead of bytecode",
    )
    output_group.add_argument(
        "--json",
        action="store_true",
        help="Output JSON with bytecode, ABI, and optionally IR/asm",
    )
    output_group.add_argument(
        "--abi",
        action="store_true",
        help="Output ABI only",
    )

    parser.add_argument(
        "--no-optimize",
        action="store_true",
        help="Disable optimization",
    )

    parser.add_argument(
        "--evm-version",
        type=str,
        default="cancun",
        help="Target EVM version (default: cancun)",
    )

    parser.add_argument(
        "--library", "-l",
        action="append",
        type=_parse_library_arg,
        default=[],
        dest="libraries",
        metavar="NAME=ADDRESS",
        help="Link library at address (can be repeated)",
    )

    parser.add_argument(
        "--solc",
        type=str,
        default="solc",
        help="Path to solc binary (default: solc in PATH)",
    )

    parser.add_argument(
        "--vyper-path",
        type=str,
        default=None,
        help="Path to Vyper repository (auto-detected if not specified)",
    )

    parser.add_argument(
        "--verbose", "-v",
        action="store_true",
        help="Verbose output",
    )

    # Import resolution options
    parser.add_argument(
        "--base-path",
        type=Path,
        default=None,
        help="Root directory for import resolution",
    )

    parser.add_argument(
        "--include-path", "-I",
        action="append",
        type=Path,
        default=[],
        dest="include_paths",
        metavar="PATH",
        help="Additional directory to search for imports (can be repeated)",
    )

    parser.add_argument(
        "--remapping", "-r",
        action="append",
        type=str,
        default=[],
        dest="remappings",
        metavar="CONTEXT:PREFIX=TARGET",
        help="Import remapping (e.g., @openzeppelin/=lib/openzeppelin/) (can be repeated)",
    )

    args = parser.parse_args()

    # Validate input file
    if not args.solidity_file.exists():
        print(f"Error: File not found: {args.solidity_file}", file=sys.stderr)
        sys.exit(1)

    if not args.solidity_file.suffix == ".sol":
        print(f"Warning: File does not have .sol extension", file=sys.stderr)

    # Parse library addresses
    library_addresses = dict(args.libraries) if args.libraries else None

    # Create compiler
    try:
        compiler = SolVenomCompiler(
            solc_path=args.solc,
            vyper_path=args.vyper_path,
            evm_version=args.evm_version,
        )
    except Exception as e:
        print(f"Error initializing compiler: {e}", file=sys.stderr)
        sys.exit(1)

    optimize = not args.no_optimize

    # Prepare import resolution options
    base_path = args.base_path
    include_paths = args.include_paths if args.include_paths else None
    remappings = args.remappings if args.remappings else None

    try:
        if args.all:
            # Compile all contracts
            result = compiler.compile_all(
                args.solidity_file,
                optimize=optimize,
                output_venom=args.json,
                output_asm=args.json,
                library_addresses=library_addresses,
                base_path=base_path,
                include_paths=include_paths,
                remappings=remappings,
            )

            if args.json:
                output = {
                    "contracts": {
                        name: {
                            "contractName": r.contract_name,
                            "fullyQualifiedName": r.fully_qualified_name,
                            "bytecode": r.deploy_bytecode,
                            "abi": r.abi,
                            "venomIR": r.venom_ir,
                            "assembly": r.assembly,
                        }
                        for name, r in result.contracts.items()
                    },
                    "primaryContract": result.primary_contract,
                    "warnings": result.warnings,
                }
                print(json.dumps(output, indent=2))
            else:
                for name, r in result.contracts.items():
                    print(f"# {name}")
                    print(r.deploy_bytecode)
                    print()

                if result.warnings:
                    for w in result.warnings:
                        print(f"Warning: {w}", file=sys.stderr)

        else:
            # Compile single contract
            result = compiler.compile(
                args.solidity_file,
                contract_name=args.contract,
                optimize=optimize,
                output_venom=args.venom or args.json,
                output_asm=args.asm or args.json,
                library_addresses=library_addresses,
                base_path=base_path,
                include_paths=include_paths,
                remappings=remappings,
            )

            if args.verbose:
                print(f"Compiled: {result.fully_qualified_name}", file=sys.stderr)

            if args.json:
                output = {
                    "contractName": result.contract_name,
                    "fullyQualifiedName": result.fully_qualified_name,
                    "bytecode": result.deploy_bytecode,
                    "abi": result.abi,
                    "venomIR": result.venom_ir,
                    "assembly": result.assembly,
                }
                print(json.dumps(output, indent=2))
            elif args.abi:
                print(json.dumps(result.abi, indent=2))
            elif args.venom:
                print(result.venom_ir)
            elif args.asm:
                print(result.assembly)
            else:
                print(result.deploy_bytecode)

    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        if args.verbose:
            import traceback
            traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()
