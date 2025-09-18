#!/usr/bin/env python3
"""
Yul transpiler wrapper for compiling Yul to Venom IR and bytecode.
"""

import sys
import subprocess
from pathlib import Path
from typing import Optional, Tuple, Dict, Any
import tempfile
import os

# Add parent directories to path for imports
sys.path.insert(0, str(Path(__file__).parent.parent.parent))
sys.path.insert(0, "/Users/harkal/projects/charles_cooper/repos/vyper")

# Import directly from the local yul.py file
sys.path.insert(0, str(Path(__file__).parent.parent.parent / "vyper" / "cli"))
import yul as yul_module

# Import Vyper modules
from vyper.venom import generate_assembly_experimental
from vyper.compiler.phases import generate_bytecode
from vyper.compiler.settings import OptimizationLevel


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
    
    def compile_yul_to_bytecode(self, yul_code: str, 
                                evm_version: str = "cancun",
                                optimize: bool = False) -> str:
        """
        Compile Yul code to EVM bytecode via Venom IR.
        
        Args:
            yul_code: Yul source code
            evm_version: Target EVM version
            optimize: Whether to apply optimizations
        
        Returns:
            Hex-encoded bytecode string
        """
        # Parse Yul code
        tree = yul_module.yul_parser.parse(yul_code)
        ast = yul_module.YulTransformer().transform(tree)
        
        # Handle both single object and list of objects
        if isinstance(ast, list) and len(ast) > 0:
            ast = ast[0]
        
        # Compile to Venom IR
        # Note: compile_to_venom doesn't take evm_version parameter
        ctx = yul_module.compile_to_venom(ast)
        
        # Always run the Venom pass pipeline to satisfy codegen invariants.
        # Filter out data-only functions before running passes/assembly.
        from vyper.venom import run_passes_on
        original_functions = getattr(ctx, "functions", None)
        if hasattr(ctx, "functions"):
            ctx.functions = {name: fn for name, fn in ctx.functions.items()
                             if not getattr(fn, "is_data_section", False)}
        run_passes_on(ctx, OptimizationLevel.GAS if optimize else OptimizationLevel.NONE)
        
        # Generate assembly
        asm = generate_assembly_experimental(
            ctx, OptimizationLevel.NONE if not optimize else OptimizationLevel.GAS
        )

        # Restore original functions (to keep data functions available for labeling)
        if original_functions is not None:
            ctx.functions = original_functions

        # Inject embedded bytecode (data sections) if present
        embedded_bytecode = getattr(ctx, "embedded_bytecode", None)
        program_end_label_name = getattr(ctx, "program_end_label_name", None)
        asm = yul_module.inject_embedded_bytecode(asm, embedded_bytecode, program_end_label_name)
        
        # Generate bytecode
        bytecode, _ = generate_bytecode(asm)
        
        return "0x" + bytecode.hex()
    
    def compile_yul_to_venom_ir(self, yul_code: str,
                               evm_version: str = "cancun") -> str:
        """
        Compile Yul code to Venom IR.
        
        Args:
            yul_code: Yul source code
            evm_version: Target EVM version
        
        Returns:
            Venom IR as string
        """
        # Parse Yul code
        tree = yul_module.yul_parser.parse(yul_code)
        ast = yul_module.YulTransformer().transform(tree)
        
        # Handle both single object and list of objects
        if isinstance(ast, list) and len(ast) > 0:
            ast = ast[0]
        
        # Compile to Venom IR
        # Note: compile_to_venom doesn't take evm_version parameter
        ctx = yul_module.compile_to_venom(ast)
        
        # Return string representation of Venom IR
        return str(ctx)
    
    def compile_yul_to_assembly(self, yul_code: str,
                               evm_version: str = "cancun",
                               optimize: bool = False) -> str:
        """
        Compile Yul code to assembly.
        
        Args:
            yul_code: Yul source code
            evm_version: Target EVM version
            optimize: Whether to apply optimizations
        
        Returns:
            Assembly as string
        """
        # Parse Yul code
        tree = yul_module.yul_parser.parse(yul_code)
        ast = yul_module.YulTransformer().transform(tree)
        
        # Handle both single object and list of objects
        if isinstance(ast, list) and len(ast) > 0:
            ast = ast[0]
        
        # Compile to Venom IR
        # Note: compile_to_venom doesn't take evm_version parameter
        ctx = yul_module.compile_to_venom(ast)
        
        # Always run passes for structural invariants (filter out data-only functions)
        from vyper.venom import run_passes_on
        original_functions = getattr(ctx, "functions", None)
        if hasattr(ctx, "functions"):
            ctx.functions = {name: fn for name, fn in ctx.functions.items()
                             if not getattr(fn, "is_data_section", False)}
        run_passes_on(ctx, OptimizationLevel.GAS if optimize else OptimizationLevel.NONE)
        
        # Generate assembly
        asm = generate_assembly_experimental(
            ctx, OptimizationLevel.NONE if not optimize else OptimizationLevel.GAS
        )

        # Restore original functions
        if original_functions is not None:
            ctx.functions = original_functions

        # Inject embedded bytecode (data sections) if present
        embedded_bytecode = getattr(ctx, "embedded_bytecode", None)
        program_end_label_name = getattr(ctx, "program_end_label_name", None)
        asm = yul_module.inject_embedded_bytecode(asm, embedded_bytecode, program_end_label_name)
        
        return str(asm)
    
    def compile_yul_file(self, yul_file: Path,
                        evm_version: str = "cancun",
                        optimize: bool = True) -> str:
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
        
        return self.compile_yul_to_bytecode(yul_code, evm_version, optimize)
    
    def compile_via_cli(self, yul_file: Path,
                       output_format: str = "bytecode",
                       evm_version: str = "cancun") -> str:
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
