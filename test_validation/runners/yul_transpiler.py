#!/usr/bin/env python3
"""
Yul transpiler wrapper for compiling Yul to Venom IR and bytecode.
"""

from __future__ import annotations

import os
import subprocess
import sys
from collections import OrderedDict
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Dict, List, Mapping, Optional, Tuple

from yul_to_venom.cli import yul as yul_module
from yul_to_venom.cli.yul import (
    Assign,
    Block,
    ExprStmt,
    ForLoop,
    FuncCall,
    FunctionDef,
    If,
    Literal,
    Switch,
    VarDecl,
    YulObject,
)
from vyper.compiler.phases import generate_bytecode
from vyper.compiler.settings import OptimizationLevel, VenomOptimizationFlags
from vyper.venom import generate_assembly_experimental, run_passes_on


@dataclass(frozen=True)
class YulObjectInfo:
    name: str
    base_name: str
    ast: Any


@dataclass(frozen=True)
class YulBytecodeArtifact:
    """Container for compiled deploy/runtime bytecode artefacts."""

    deploy_bytecode: str
    runtime_sections: Mapping[str, bytes]


class YulTranspiler:
    """Wrapper for the Yul to Venom transpiler."""

    def __init__(self, vyper_path: str | os.PathLike[str] | None = None):
        """
        Initialize the YulTranspiler.

        Args:
            vyper_path: Optional path to the Vyper repository.
        """
        candidate_paths: list[Path] = []

        if vyper_path is not None:
            candidate_paths.append(Path(vyper_path))
        else:
            env_path = os.environ.get("VYPER_REPO") or os.environ.get("VYPER_PATH")
            if env_path:
                candidate_paths.append(Path(env_path))

            repo_root = Path(__file__).resolve().parents[2]
            candidate_paths.append(repo_root / "vyper")
            candidate_paths.append(repo_root.parent / "vyper")

        resolved_path: Path | None = None
        for candidate in candidate_paths:
            if candidate and candidate.exists():
                resolved_path = candidate.resolve()
                break

        if resolved_path is None:
            tried = ", ".join(str(path) for path in candidate_paths if path)
            raise ValueError(
                f"Unable to locate Vyper repository. Tried: {tried or '<none>'}. "
                "Specify the path explicitly via YulTranspiler(vyper_path=...) or set VYPER_REPO."
            )

        self.vyper_path = resolved_path
    
    def compile_yul_to_bytecode(
        self,
        yul_code: str,
        evm_version: str = "cancun",
        optimize: bool = False,
        object_name: Optional[str] = None,
        link_libraries: Optional[Mapping[str, int | str]] = None,
        return_details: bool = False,
    ) -> str | YulBytecodeArtifact:
        """
        Compile Yul code to EVM bytecode via Venom IR.

        Args:
            yul_code: Yul source code
            evm_version: Target EVM version
            optimize: Whether to apply optimizations
            object_name: Optional specific Yul object to compile (top-level)
            link_libraries: Mapping of linkersymbol identifiers to addresses
            return_details: When True, include runtime metadata in the result

        Returns:
            Hex-encoded bytecode string
        """
        artifact = self._compile_yul_to_bytecode_artifact(
            yul_code,
            evm_version=evm_version,
            optimize=optimize,
            object_name=object_name,
            link_libraries=link_libraries,
        )

        if return_details:
            return artifact

        return artifact.deploy_bytecode
    
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
        ctx, _, _ = self._compile_yul_object_to_ctx(
            yul_object,
            optimize=False,
            link_libraries=link_libraries,
            run_passes=False,
            allow_unresolved=True,
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
        ctx, data_functions, _ = self._compile_yul_object_to_ctx(
            yul_object,
            optimize=optimize,
            link_libraries=link_libraries,
            run_passes=True,
            allow_unresolved=False,
        )

        asm = generate_assembly_experimental(
            ctx, OptimizationLevel.NONE if not optimize else OptimizationLevel.GAS
        )

        embedded_bytecode = getattr(ctx, "embedded_bytecode", None)
        program_end_label_name = getattr(ctx, "program_end_label_name", None)
        asm = yul_module.inject_embedded_bytecode(asm, embedded_bytecode, program_end_label_name)

        if data_functions and hasattr(ctx, "functions"):
            ctx.functions.update(data_functions)

        return str(asm)

    def _compile_yul_to_bytecode_artifact(
        self,
        yul_code: str,
        evm_version: str,
        optimize: bool,
        object_name: Optional[str],
        link_libraries: Optional[Mapping[str, int | str]],
    ) -> YulBytecodeArtifact:
        yul_object = self._select_yul_object(yul_code, object_name)
        ctx, data_functions, _ = self._compile_yul_object_to_ctx(
            yul_object,
            optimize=optimize,
            link_libraries=link_libraries,
            run_passes=True,
            allow_unresolved=False,
        )

        asm = generate_assembly_experimental(
            ctx, OptimizationLevel.NONE if not optimize else OptimizationLevel.GAS
        )

        embedded_bytecode = getattr(ctx, "embedded_bytecode", None)
        program_end_label_name = getattr(ctx, "program_end_label_name", None)
        asm = yul_module.inject_embedded_bytecode(asm, embedded_bytecode, program_end_label_name)

        bytecode, _ = generate_bytecode(asm)

        runtime_sections: "OrderedDict[str, bytes]" = OrderedDict()
        if embedded_bytecode:
            for label in self._find_runtime_data_labels(yul_object):
                data_key = f"{label}_data"
                data_bytes = embedded_bytecode.get(data_key)
                if isinstance(data_bytes, bytes):
                    runtime_sections[label] = data_bytes

        if data_functions and hasattr(ctx, "functions"):
            ctx.functions.update(data_functions)

        return YulBytecodeArtifact(
            deploy_bytecode="0x" + bytecode.hex(),
            runtime_sections=runtime_sections,
        )

    def _find_runtime_data_labels(self, yul_object: Any) -> Tuple[str, ...]:
        """Best-effort detection of data sections returned by constructor code."""

        runtime_labels: List[str] = []
        scope_stack: List[Dict[str, str]] = [{}]

        def strip_quotes(value: str) -> str:
            return value.strip('"')

        def resolve_var(name: str) -> Optional[str]:
            for scope in reversed(scope_stack):
                if name in scope:
                    return scope[name]
            return None

        def set_var(name: str, label: Optional[str]) -> None:
            if label is None:
                scope_stack[-1].pop(name, None)
            else:
                scope_stack[-1][name] = label

        def resolve_expr(expr: Any) -> Optional[str]:
            if isinstance(expr, str):
                return resolve_var(expr)
            if isinstance(expr, Literal) and isinstance(expr.value, str):
                # String literals only map to data labels when referenced through datasize/dataoffset
                return None
            if isinstance(expr, FuncCall):
                if expr.name in {"datasize", "dataoffset"} and expr.args:
                    arg = expr.args[0]
                    if isinstance(arg, Literal) and isinstance(arg.value, str):
                        cleaned = strip_quotes(arg.value)
                        return cleaned
                for sub_expr in expr.args:
                    label = resolve_expr(sub_expr)
                    if label is not None:
                        return label
            return None

        def visit_block(block: Block, create_scope: bool = True) -> None:
            if create_scope:
                scope_stack.append({})
            for statement in block.statements:
                visit_statement(statement)
            if create_scope:
                scope_stack.pop()

        def visit_statement(stmt: Any) -> None:
            if isinstance(stmt, Block):
                visit_block(stmt)
            elif isinstance(stmt, VarDecl):
                label = resolve_expr(stmt.init) if stmt.init is not None else None
                for name in stmt.names:
                    set_var(name, label)
            elif isinstance(stmt, Assign):
                label = resolve_expr(stmt.value)
                for name in stmt.targets:
                    set_var(name, label)
            elif isinstance(stmt, ExprStmt) and isinstance(stmt.expr, FuncCall):
                call = stmt.expr
                if call.name == "return" and len(call.args) >= 2:
                    label = resolve_expr(call.args[1])
                    if label and label not in runtime_labels:
                        runtime_labels.append(label)
                else:
                    for arg in call.args:
                        resolve_expr(arg)
            elif isinstance(stmt, If):
                visit_block(stmt.body)
            elif isinstance(stmt, Switch):
                for case in stmt.cases:
                    visit_block(case.body)
                if stmt.default is not None:
                    visit_block(stmt.default)
            elif isinstance(stmt, ForLoop):
                scope_stack.append({})
                visit_block(stmt.init, create_scope=False)
                visit_block(stmt.body)
                visit_block(stmt.post, create_scope=False)
                scope_stack.pop()

        if hasattr(yul_object, "code") and hasattr(yul_object.code, "block"):
            visit_block(yul_object.code.block)

        return tuple(runtime_labels)

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
            str(Path(__file__).parent.parent.parent / "yul_to_venom" / "cli" / "yul.py"),
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
        allow_unresolved: bool,
    ) -> tuple[Any, Dict[str, Any], set[str]]:
        link_map = self._normalize_link_libraries(link_libraries)
        ctx = yul_module.compile_to_venom(yul_object, link_libraries=link_map or None)

        unresolved = getattr(ctx, "unresolved_link_references", set())
        if unresolved and not allow_unresolved:
            missing = ", ".join(sorted(unresolved))
            raise ValueError(f"Unresolved linkersymbol references: {missing}")

        data_functions: Dict[str, Any] = {}
        if run_passes:
            original_functions = getattr(ctx, "functions", None)
            if hasattr(ctx, "functions"):
                ctx.functions, data_functions = self._split_code_and_data_functions(original_functions)

            run_passes_on(ctx, VenomOptimizationFlags())

        return ctx, data_functions, set(unresolved)

    @staticmethod
    def _split_code_and_data_functions(functions: Dict[str, Any]) -> tuple[Dict[str, Any], Dict[str, Any]]:
        code_functions: Dict[str, Any] = {}
        data_functions: Dict[str, Any] = {}
        for name, fn in functions.items():
            if getattr(fn, "is_data_section", False):
                data_functions[name] = fn
            else:
                code_functions[name] = fn
        return code_functions, data_functions

    def get_linker_dependencies(
        self,
        yul_code: str,
        object_name: Optional[str] = None,
    ) -> set[str]:
        """Return linkersymbol identifiers referenced by the specified object."""

        yul_object = self._select_yul_object(yul_code, object_name)
        dependencies: set[str] = set()

        def visit_expr(expr: Any) -> None:
            if isinstance(expr, FuncCall):
                if expr.name == "linkersymbol" and expr.args:
                    arg = expr.args[0]
                    if isinstance(arg, Literal) and isinstance(arg.value, str):
                        cleaned = arg.value.strip('"')
                        cleaned = cleaned.strip("'")
                        dependencies.add(cleaned)
                for sub_expr in expr.args:
                    visit_expr(sub_expr)
            elif isinstance(expr, (list, tuple)):
                for sub_expr in expr:
                    visit_expr(sub_expr)

        def visit_block(block: Block) -> None:
            for stmt in block.statements:
                visit_statement(stmt)

        def visit_statement(stmt: Any) -> None:
            if isinstance(stmt, Block):
                visit_block(stmt)
            elif isinstance(stmt, FunctionDef):
                visit_block(stmt.body)
            elif isinstance(stmt, VarDecl):
                if stmt.init is not None:
                    visit_expr(stmt.init)
            elif isinstance(stmt, Assign):
                visit_expr(stmt.value)
            elif isinstance(stmt, If):
                visit_expr(stmt.cond)
                visit_block(stmt.body)
            elif isinstance(stmt, Switch):
                visit_expr(stmt.expr)
                for case in stmt.cases:
                    visit_expr(case.value)
                    visit_block(case.body)
                if stmt.default is not None:
                    visit_block(stmt.default)
            elif isinstance(stmt, ForLoop):
                visit_block(stmt.init)
                visit_expr(stmt.cond)
                visit_block(stmt.post)
                visit_block(stmt.body)
            elif isinstance(stmt, ExprStmt):
                visit_expr(stmt.expr)
            # Break, Continue, Leave have no expressions to visit

        def visit_object(obj: YulObject) -> None:
            if obj.code:
                visit_block(obj.code.block)
            for sub in obj.subobjects:
                if isinstance(sub, YulObject):
                    visit_object(sub)

        visit_object(yul_object)
        return dependencies

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
