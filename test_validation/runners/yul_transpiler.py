#!/usr/bin/env python3
"""
Yul transpiler wrapper for compiling Yul to Venom IR and bytecode.
"""

from __future__ import annotations

import os
import sys
import subprocess
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Dict, List, Mapping, Optional, Tuple

# Add parent directories to path for imports
sys.path.insert(0, str(Path(__file__).parent.parent.parent))
sys.path.insert(0, "/Users/harkal/projects/charles_cooper/repos/vyper")

# Import directly from the local yul.py file
sys.path.insert(0, str(Path(__file__).parent.parent.parent / "vyper" / "cli"))
import yul as yul_module

# Import Vyper modules
from vyper.venom import generate_assembly_experimental, run_passes_on
from vyper.compiler.phases import generate_bytecode
from vyper.compiler.settings import OptimizationLevel


@dataclass(frozen=True)
class YulObjectInfo:
    name: str
    base_name: str
    ast: Any


class YulTranspiler:
    """Wrapper for the Yul to Venom transpiler."""
    
    def __init__(self, vyper_path: str = "/Users/harkal/projects/charles_cooper/repos/vyper"):
        """
        Initialize the YulTranspiler.
        
        Args:
            vyper_path: Path to the Vyper repository
        """
        self.vyper_path = Path(vyper_path)
        if not self.vyper_path.exists():
            raise ValueError(f"Vyper path does not exist: {vyper_path}")
        
        # Add Vyper to Python path
        if str(self.vyper_path) not in sys.path:
            sys.path.insert(0, str(self.vyper_path))
    
    def compile_yul_to_bytecode(
        self,
        yul_code: str,
        evm_version: str = "cancun",
        optimize: bool = False,
        object_name: Optional[str] = None,
        link_libraries: Optional[Mapping[str, int | str]] = None,
    ) -> str:
        """
        Compile Yul code to EVM bytecode via Venom IR.

        Args:
            yul_code: Yul source code
            evm_version: Target EVM version
            optimize: Whether to apply optimizations
            object_name: Optional specific Yul object to compile (top-level)
            link_libraries: Mapping of linkersymbol identifiers to addresses

        Returns:
            Hex-encoded bytecode string
        """
        yul_object = self._select_yul_object(yul_code, object_name)
        ctx = self._compile_yul_object_to_ctx(
            yul_object, optimize=optimize, link_libraries=link_libraries, run_passes=True
        )

        asm = generate_assembly_experimental(
            ctx, OptimizationLevel.NONE if not optimize else OptimizationLevel.GAS
        )

        embedded_bytecode = getattr(ctx, "embedded_bytecode", None)
        program_end_label_name = getattr(ctx, "program_end_label_name", None)
        asm = yul_module.inject_embedded_bytecode(asm, embedded_bytecode, program_end_label_name)

        bytecode, _ = generate_bytecode(asm)

        return "0x" + bytecode.hex()
    
    def compile_yul_to_venom_ir(
        self,
        yul_code: str,
        evm_version: str = "cancun",
        object_name: Optional[str] = None,
        link_libraries: Optional[Mapping[str, int | str]] = None,
    ) -> str:
        """
        Compile Yul code to Venom IR.
        
        Args:
            yul_code: Yul source code
            evm_version: Target EVM version
        
        Returns:
            Venom IR as string
        """
        yul_object = self._select_yul_object(yul_code, object_name)
        ctx = self._compile_yul_object_to_ctx(
            yul_object, optimize=False, link_libraries=link_libraries, run_passes=False
        )
        return str(ctx)
    
    def compile_yul_to_assembly(
        self,
        yul_code: str,
        evm_version: str = "cancun",
        optimize: bool = False,
        object_name: Optional[str] = None,
        link_libraries: Optional[Mapping[str, int | str]] = None,
    ) -> str:
        """
        Compile Yul code to assembly.
        
        Args:
            yul_code: Yul source code
            evm_version: Target EVM version
            optimize: Whether to apply optimizations
        
        Returns:
            Assembly as string
        """
        yul_object = self._select_yul_object(yul_code, object_name)
        ctx = self._compile_yul_object_to_ctx(
            yul_object, optimize=optimize, link_libraries=link_libraries, run_passes=True
        )

        asm = generate_assembly_experimental(
            ctx, OptimizationLevel.NONE if not optimize else OptimizationLevel.GAS
        )

        embedded_bytecode = getattr(ctx, "embedded_bytecode", None)
        program_end_label_name = getattr(ctx, "program_end_label_name", None)
        asm = yul_module.inject_embedded_bytecode(asm, embedded_bytecode, program_end_label_name)

        return str(asm)
    
    def compile_yul_file(
        self,
        yul_file: Path,
        evm_version: str = "cancun",
        optimize: bool = True,
        object_name: Optional[str] = None,
        link_libraries: Optional[Mapping[str, int | str]] = None,
    ) -> str:
        """
        Compile a Yul file to bytecode.
        
        Args:
            yul_file: Path to Yul file
            evm_version: Target EVM version
            optimize: Whether to apply optimizations
        
        Returns:
            Hex-encoded bytecode string
        """
        if not yul_file.exists():
            raise FileNotFoundError(f"Yul file not found: {yul_file}")
        
        with open(yul_file, 'r') as f:
            yul_code = f.read()
        
        return self.compile_yul_to_bytecode(
            yul_code,
            evm_version=evm_version,
            optimize=optimize,
            object_name=object_name,
            link_libraries=link_libraries,
        )
    
    def compile_via_cli(
        self,
        yul_file: Path,
        output_format: str = "bytecode",
        evm_version: str = "cancun",
        link_libraries: Optional[Mapping[str, int | str]] = None,
    ) -> str:
        """
        Compile Yul using the CLI interface (for testing CLI compatibility).
        
        Args:
            yul_file: Path to Yul file
            output_format: One of "bytecode", "venom", "asm"
            evm_version: Target EVM version
        
        Returns:
            Compilation output as string
        """
        cmd = [
            sys.executable,
            str(Path(__file__).parent.parent.parent / "vyper" / "cli" / "yul.py"),
            str(yul_file),
            "--evm-version", evm_version
        ]
        
        if output_format == "venom":
            cmd.append("--venom")
        elif output_format == "asm":
            cmd.append("--asm")
        
        env = os.environ.copy()
        env["PYTHONPATH"] = f"{self.vyper_path}:."

        if link_libraries:
            for identifier, value in link_libraries.items():
                normalized = self._normalize_link_library_value(value)
                cmd.extend([
                    "--link-library",
                    f"{identifier}=0x{normalized:040x}",
                ])

        try:
            result = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                check=True,
                env=env
            )
            return result.stdout.strip()
        except subprocess.CalledProcessError as e:
            raise RuntimeError(f"CLI compilation failed: {e.stderr}")
    
    def validate_yul_syntax(self, yul_code: str) -> Tuple[bool, Optional[str]]:
        """
        Validate Yul syntax without compiling.
        
        Args:
            yul_code: Yul source code
        
        Returns:
            Tuple of (is_valid, error_message)
        """
        try:
            tree = yul_module.yul_parser.parse(yul_code)
            ast = yul_module.YulTransformer().transform(tree)
            return True, None
        except Exception as e:
            return False, str(e)
    
    def get_ast(self, yul_code: str) -> Any:
        """
        Get the AST for Yul code.
        
        Args:
            yul_code: Yul source code
        
        Returns:
            AST object
        """
        tree = yul_module.yul_parser.parse(yul_code)
        ast = yul_module.YulTransformer().transform(tree)
        
        # Handle both single object and list of objects
        if isinstance(ast, list) and len(ast) > 0:
            ast = ast[0]

        return ast

    def list_objects(self, yul_code: str) -> Dict[str, YulObjectInfo]:
        """Return mapping of object name to metadata for the provided Yul code."""

        objects = self._parse_yul(yul_code)
        result: Dict[str, YulObjectInfo] = {}
        for obj in objects:
            base = obj.name.split("_", 1)[0]
            result[obj.name] = YulObjectInfo(name=obj.name, base_name=base, ast=obj)
        return result

    def _select_yul_object(self, yul_code: str, object_name: Optional[str]) -> Any:
        objects = self._parse_yul(yul_code)
        if not objects:
            raise ValueError("No Yul objects found in input")

        if object_name is None:
            if len(objects) != 1:
                available = ", ".join(obj.name for obj in objects)
                raise ValueError(
                    "Multiple Yul objects detected; specify object_name explicitly. "
                    f"Available: {available}"
                )
            return objects[0]

        # exact match first.
        for obj in objects:
            if obj.name == object_name:
                return obj

        # prefix match on base name (before first underscore).
        candidates = [obj for obj in objects if obj.name.split("_", 1)[0] == object_name]
        if len(candidates) == 1:
            return candidates[0]

        if not candidates:
            available = ", ".join(obj.name for obj in objects)
            raise KeyError(f"Yul object '{object_name}' not found. Available: {available}")

        names = ", ".join(obj.name for obj in candidates)
        raise KeyError(
            f"Ambiguous Yul object selector '{object_name}'. Candidates: {names}. "
            "Specify the full object name."
        )

    def _compile_yul_object_to_ctx(
        self,
        yul_object: Any,
        *,
        optimize: bool,
        link_libraries: Optional[Mapping[str, int | str]] = None,
        run_passes: bool,
    ) -> Any:
        link_map = self._normalize_link_libraries(link_libraries)
        ctx = yul_module.compile_to_venom(yul_object, link_libraries=link_map or None)

        unresolved = getattr(ctx, "unresolved_link_references", set())
        if unresolved:
            missing = ", ".join(sorted(unresolved))
            raise ValueError(f"Unresolved linkersymbol references: {missing}")

        if run_passes:
            original_functions = getattr(ctx, "functions", None)
            if hasattr(ctx, "functions"):
                ctx.functions = {
                    name: fn
                    for name, fn in ctx.functions.items()
                    if not getattr(fn, "is_data_section", False)
                }

            run_passes_on(ctx, OptimizationLevel.GAS if optimize else OptimizationLevel.NONE)

            if original_functions is not None:
                ctx.functions = original_functions

        return ctx

    @staticmethod
    def _normalize_link_libraries(
        link_libraries: Optional[Mapping[str, int | str]]
    ) -> Dict[str, int]:
        if not link_libraries:
            return {}

        normalized: Dict[str, int] = {}
        for identifier, value in link_libraries.items():
            normalized[identifier] = YulTranspiler._normalize_link_library_value(value)
        return normalized

    @staticmethod
    def _normalize_link_library_value(value: int | str) -> int:
        if isinstance(value, int):
            if value < 0:
                raise ValueError("Library address cannot be negative")
            return value

        value_str = value.strip().lower()
        if value_str.startswith("0x"):
            value_str = value_str[2:]

        if not value_str:
            raise ValueError("Library address cannot be empty")

        return int(value_str, 16)

    def _parse_yul(self, yul_code: str) -> List[Any]:
        tree = yul_module.yul_parser.parse(yul_code)
        ast = yul_module.YulTransformer().transform(tree)

        if isinstance(ast, list):
            return list(ast)

        return [ast]


def main():
    """Test the transpiler wrapper."""
    import sys
    
    if len(sys.argv) < 2:
        print("Usage: python yul_transpiler.py <yul_file>")
        sys.exit(1)
    
    transpiler = YulTranspiler()
    yul_file = Path(sys.argv[1])
    
    print(f"Compiling: {yul_file}")
    
    # Test different outputs
    print("\n=== Bytecode ===")
    bytecode = transpiler.compile_yul_file(yul_file)
    print(f"{bytecode[:100]}..." if len(bytecode) > 100 else bytecode)
    
    print("\n=== Venom IR ===")
    with open(yul_file, 'r') as f:
        yul_code = f.read()
    venom_ir = transpiler.compile_yul_to_venom_ir(yul_code)
    print(venom_ir[:500] + "..." if len(venom_ir) > 500 else venom_ir)
    
    print("\n=== Assembly ===")
    asm = transpiler.compile_yul_to_assembly(yul_code)
    print(asm[:500] + "..." if len(asm) > 500 else asm)


if __name__ == "__main__":
    main()
