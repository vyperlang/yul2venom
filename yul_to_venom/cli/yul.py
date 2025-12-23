#!/usr/bin/env python3
from __future__ import annotations
import argparse
import re
import sys

from lark import Lark

import vyper
import vyper.evm.opcodes as evm
from abi_decode_handler import (
    get_load_instruction_for_type,
    get_type_mask,
    needs_special_handling,
    parse_abi_decode_pattern,
)
from vyper.compiler.phases import generate_bytecode
from vyper.compiler.settings import Settings, set_global_settings, VenomOptimizationFlags
from vyper.venom import generate_assembly_experimental, run_passes_on
from vyper.venom.basicblock import IRBasicBlock, IRLabel, IRLiteral, IRVariable
from vyper.venom.check_venom import check_venom_ctx
from vyper.venom.context import IRContext
from vyper.venom.function import IRFunction
from vyper.venom.parser import parse_venom
from eth_utils import keccak

"""
Standalone entry point into venom compiler. Parses venom input and emits
bytecode.
"""


def inject_embedded_bytecode(
    asm, embedded_bytecode, program_end_label_name: str | None = None
):
    """Inject embedded bytecode into the assembly as raw data."""

    from vyper.evm.assembler.instructions import DataHeader, DATA_ITEM, Label

    if embedded_bytecode:
        # Append the embedded bytecode at the end of the assembly using the
        # same format as Vyper uses for runtime code
        for label_name, bytecode in embedded_bytecode.items():
            data_segment = [DataHeader(Label(label_name)), DATA_ITEM(bytecode)]
            asm.extend(data_segment)

    if program_end_label_name:
        # Ensure a label exists to mark the end of the program so datasize()
        # can resolve to a concrete offset during assembly.
        program_end_label = Label(program_end_label_name)
        if not any(
            isinstance(item, Label) and item.label == program_end_label_name for item in asm
        ):
            asm.append(program_end_label)

    return asm

def _parse_link_library_args(
    parser: argparse.ArgumentParser, entries: list[str] | None
) -> dict[str, int]:
    """Parse --link-library arguments into a mapping."""

    link_libraries: dict[str, int] = {}

    if not entries:
        return link_libraries

    for raw_entry in entries:
        if "=" not in raw_entry:
            parser.error(
                f"Invalid --link-library value '{raw_entry}'. Expected format identifier=address"
            )

        identifier, address_str = raw_entry.split("=", 1)
        identifier = identifier.strip()
        if not identifier:
            parser.error("--link-library identifier cannot be empty")

        address_str = address_str.strip()
        if not address_str:
            parser.error(f"Missing address for --link-library {identifier}")

        if address_str.startswith("0x") or address_str.startswith("0X"):
            address_str = address_str[2:]

        if not re.fullmatch(r"[0-9a-fA-F]+", address_str):
            parser.error(
                f"Invalid address '{address_str}' for --link-library {identifier}. Expected hex string"
            )

        if len(address_str) > 40:
            parser.error(
                f"Address for --link-library {identifier} is too long; expected 20 bytes (40 hex chars)"
            )

        # Left-pad to 20 bytes so users can provide short addresses like '1'.
        address_str = address_str.rjust(40, "0")

        address_value = int(address_str, 16)

        if address_value >= 1 << 160:
            parser.error(
                f"Address for --link-library {identifier} exceeds 160 bits"
            )

        link_libraries[identifier] = address_value

    return link_libraries


def _handle_unresolved_link_refs(unresolved: set[str], link_libraries: dict[str, int]) -> None:
    """Report unresolved linkersymbols, erroring when the user attempted to link."""
    if not unresolved:
        return

    unresolved_list = ", ".join(sorted(unresolved))

    if link_libraries:
        print(
            f"Error: unresolved linkersymbol references: {unresolved_list}. Provide matching --link-library entries.",
            file=sys.stderr,
        )
        sys.exit(1)

    print(
        f"Warning: unresolved linkersymbol references: {unresolved_list}. Addresses default to 0x0; supply --link-library to link them.",
        file=sys.stderr,
    )


def _parse_cli_args():
    return _parse_args(sys.argv[1:])


def _parse_args(argv: list[str]):
    parser = argparse.ArgumentParser(
        description="Yul IR parser & compiler", formatter_class=argparse.RawTextHelpFormatter
    )
    parser.add_argument("input_file", help="Yul sourcefile", nargs="?")
    parser.add_argument("--version", action="version", version=vyper.__long_version__)
    parser.add_argument(
        "--evm-version",
        help=f"Select desired EVM version (default {evm.DEFAULT_EVM_VERSION})",
        choices=list(evm.EVM_VERSIONS),
        dest="evm_version",
    )
    parser.add_argument("--stdin", action="store_true", help="whether to pull yul input from stdin")
    parser.add_argument("--venom", action="store_true", help="output Venom IR instead of bytecode")
    parser.add_argument("--asm", action="store_true", help="output assembly instead of bytecode")
    parser.add_argument(
        "--link-library",
        dest="link_libraries",
        action="append",
        help=(
            "Provide an address for a linkersymbol reference (repeatable). "
            "Format: identifier=0x1234... or identifier=1234..."
        ),
    )

    args = parser.parse_args(argv)
    link_libraries = _parse_link_library_args(parser, args.link_libraries)

    if args.evm_version is not None:
        set_global_settings(Settings(evm_version=args.evm_version))

    if args.stdin:
        if not sys.stdin.isatty():
            yul_source = sys.stdin.read()
        else:
            # No input provided
            print("Error: --stdin flag used but no input provided")
            sys.exit(1)
    else:
        if args.input_file is None:
            print("Error: No input file provided, either use --stdin or provide a path")
            sys.exit(1)
        with open(args.input_file, "r") as f:
            yul_source = f.read()

    tree = yul_parser.parse(yul_source)
    ast = YulTransformer().transform(tree)

    # Handle multiple top-level objects
    objects_to_compile = []
    if isinstance(ast, list):
        if len(ast) == 0:
            print("Error: No valid Yul objects found")
            sys.exit(1)
        objects_to_compile = ast
    else:
        objects_to_compile = [ast]

    # For multiple objects, compile each and concatenate output
    unresolved_symbols: set[str] = set()

    if len(objects_to_compile) > 1:
        contexts: list[tuple[YulObject, IRContext]] = []
        venom_outputs: list[str] = []

        for i, obj in enumerate(objects_to_compile):
            ctx = compile_to_venom(obj, link_libraries=link_libraries)
            unresolved_symbols.update(getattr(ctx, "unresolved_link_references", set()))
            contexts.append((obj, ctx))

            if args.venom:
                if i > 0:
                    venom_outputs.append(f"\n# === Object {i+1}: {obj.name} ===\n")
                venom_outputs.append(str(ctx))

        if args.venom:
            _handle_unresolved_link_refs(unresolved_symbols, link_libraries)
            print(''.join(venom_outputs))
            return

        # For bytecode/asm output with multiple objects
        all_bytecode = []
        all_asm = []

        for obj, ctx in contexts:
            # Filter out data functions before optimization
            original_functions = ctx.functions.copy()
            ctx.functions = {name: fn for name, fn in ctx.functions.items()
                           if not getattr(fn, 'is_data_section', False)}

            # Run full optimization pipeline
            run_passes_on(ctx, VenomOptimizationFlags())

            asm = generate_assembly_experimental(ctx)
            # Restore original functions
            ctx.functions = original_functions
            # Handle embedded bytecode and append program end label if present
            embedded_bytecode = getattr(ctx, "embedded_bytecode", None)
            program_end_label_name = getattr(ctx, "program_end_label_name", None)
            asm = inject_embedded_bytecode(asm, embedded_bytecode, program_end_label_name)

            if args.asm:
                all_asm.append(asm)
            else:
                bytecode, _ = generate_bytecode(asm)
                all_bytecode.append(bytecode)

        _handle_unresolved_link_refs(unresolved_symbols, link_libraries)

        if args.asm:
            for i, asm in enumerate(all_asm):
                if i > 0:
                    print(f"\n# === Object {i+1} ===\n")
                print(asm)
        else:
            # Concatenate all bytecodes
            combined_bytecode = b''.join(all_bytecode)
            print(f"0x{combined_bytecode.hex()}")

        return

    # Single object case (original code path)
    ctx = compile_to_venom(objects_to_compile[0], link_libraries=link_libraries)
    unresolved_symbols.update(getattr(ctx, "unresolved_link_references", set()))

    # check_venom_ctx(ctx)  # Skip check for now to see output

    if args.venom:
        # Print the Venom IR with embedded bytecode shown
        output = str(ctx)
        
        # For each data function, append the actual bytecode
        if hasattr(ctx, 'embedded_bytecode'):
            for label, bytecode in ctx.embedded_bytecode.items():
                # Find the function in the output and add bytecode display
                func_pattern = f"function {label}"
                if func_pattern in output:
                    # Replace the dbhex instruction with actual bytecode display
                    hex_str = bytecode.hex()
                    # Format as DB instructions for clarity
                    db_lines = []
                    for i in range(0, len(hex_str), 64):  # 32 bytes per line
                        db_lines.append(f"      db 0x{hex_str[i:i+64]}")
                    
                    # Replace the stop instruction with actual DB instructions for data functions
                    # Find the function and replace its stop with DB
                    import re
                    # Match the data function block and replace stop with db
                    pattern = f"function {label} {{\n  {label}:.*\n      stop"
                    replacement = f"function {label} {{\n  {label}:  ; DATA\n" + "\n".join(db_lines)
                    output = re.sub(pattern, replacement, output, flags=re.DOTALL)
        
        _handle_unresolved_link_refs(unresolved_symbols, link_libraries)
        print(output)
        return

    # Filter out data functions before optimization
    original_functions = ctx.functions.copy()
    ctx.functions = {name: fn for name, fn in ctx.functions.items()
                     if not getattr(fn, 'is_data_section', False)}

    # Run full optimization pipeline
    run_passes_on(ctx, VenomOptimizationFlags())
    
    if args.asm:
        asm = generate_assembly_experimental(ctx)
        # Restore original functions for display
        ctx.functions = original_functions
        # Handle embedded bytecode and append program end label if present
        embedded_bytecode = getattr(ctx, "embedded_bytecode", None)
        program_end_label_name = getattr(ctx, "program_end_label_name", None)
        asm = inject_embedded_bytecode(asm, embedded_bytecode, program_end_label_name)
        _handle_unresolved_link_refs(unresolved_symbols, link_libraries)
        print(asm)
        return
        
    asm = generate_assembly_experimental(ctx)
    # Restore original functions
    ctx.functions = original_functions
    # Handle embedded bytecode and append program end label if present
    embedded_bytecode = getattr(ctx, "embedded_bytecode", None)
    program_end_label_name = getattr(ctx, "program_end_label_name", None)
    asm = inject_embedded_bytecode(asm, embedded_bytecode, program_end_label_name)
    bytecode, _ = generate_bytecode(asm)
    _handle_unresolved_link_refs(unresolved_symbols, link_libraries)
    print(f"0x{bytecode.hex()}")


yul_grammar = r"""
%import common.WS
%import common.ESCAPED_STRING -> STRING
%import common.LETTER
%import common.DIGIT
%ignore WS
%ignore /\/\/[^\n]*/
%ignore /\/\*(.|\n)*?\*\//

HEXNUMBER: /0x[0-9a-fA-F]+/
DECIMALNUMBER: /\d+/
number: HEXNUMBER | DECIMALNUMBER
TRUE: "true"
FALSE: "false"

NAME: ("_"|LETTER) ("_"|LETTER|DIGIT|"$")*

?start: (object | block)+

object: "object" STRING "{" code_section (object | data_section)* "}"
code_section: "code" block
data_section: "data" STRING (HEXNUMBER | STRING | HEXSTRING)
HEXSTRING: /hex"[0-9a-fA-F]*"/

block: "{" statement* "}"
?statement: block
           | function_def
           | var_decl
           | assign
           | if_stmt
           | switch_stmt
           | for_loop
           | break_
           | continue_
           | leave
           | expr_stmt

function_def: "function" NAME "(" function_args ")" function_returns block
function_returns: ("->" typed_ids)?
function_args: typed_ids?
typed_ids: typed_id ("," typed_id)*
typed_id: NAME (":" NAME)?

var_decl: "let" typed_ids (":=" expr)?
assign: names ":=" expr
names: NAME ("," NAME)*

if_stmt: "if" expr block
switch_stmt: "switch" expr case+ default?
case: "case" literal block
default: "default" block

for_loop: "for" block expr block block
break_: "break"
continue_: "continue"
leave: "leave"

expr_stmt: expr
?expr: func_call | NAME | literal
func_call: NAME "(" (expr ("," expr)*)? ")"
literal: number (":" NAME)?
       | STRING (":" NAME)?
       | TRUE | FALSE
"""

yul_parser = Lark(yul_grammar, start="start", parser="lalr")

from dataclasses import dataclass, field
from typing import Iterable, List, Optional, Union

from lark import Token, Transformer, Tree

# --- AST node definitions ---


@dataclass
class YulObject:
    name: str
    code: CodeSection
    subobjects: list[YulObject | DataSection] = field(default_factory=list)


@dataclass
class CodeSection:
    block: "Block"


@dataclass
class DataSection:
    name: str
    value: Union[str, int]


@dataclass
class Block:
    statements: List["Statement"]


Statement = Union[
    "Block",
    "FunctionDef",
    "VarDecl",
    "Assign",
    "If",
    "Switch",
    "ForLoop",
    "Break",
    "Continue",
    "Leave",
    "ExprStmt",
]


@dataclass
class FunctionDef:
    name: str
    params: List[str]
    returns: List[str]
    body: Block


@dataclass
class VarDecl:
    names: List[str]
    init: Optional["Expr"]


@dataclass
class Assign:
    targets: List[str]
    value: "Expr"


@dataclass
class If:
    cond: "Expr"
    body: Block


@dataclass
class Case:
    value: "Literal"
    body: Block


@dataclass
class Switch:
    expr: "Expr"
    cases: List[Case]
    default: Optional[Block]


@dataclass
class ForLoop:
    init: Block
    cond: "Expr"
    post: Block
    body: Block


@dataclass
class Break:
    pass


@dataclass
class Continue:
    pass


@dataclass
class Leave:
    pass


@dataclass
class ExprStmt:
    expr: "Expr"


Expr = Union["FuncCall", "Literal", str]


@dataclass
class FuncCall:
    name: str
    args: List[Expr]


@dataclass
class Literal:
    value: Union[int, str, bool]
    type_annotation: Optional[str] = None


# --- Transformer ---


class YulTransformer(Transformer):
    def start(self, items):
        # flatten top‐level list
        return items

    def object(self, items):
        name = items[0][1:-1]  # remove quotes
        code = items[1]
        subs = items[2:]
        return YulObject(name, code, subs)

    def code_section(self, items):
        return CodeSection(items[0])

    def data_section(self, items):
        name = items[0]
        val = items[1]
        return DataSection(name, val)

    def block(self, items):
        return Block(items)

    def function_args(self, items):
        if len(items) == 0:
            return None
        assert len(items) == 1
        return items[0]

    def function_returns(self, items):
        if len(items) == 0:
            return None
        assert len(items) == 1
        return items[0]

    def function_def(self, items):
        name = items[0]
        params = items[1] or []
        returns = items[2] or []
        body = items[3]
        return FunctionDef(name, params, returns, body)

    def typed_ids(self, items):
        return items

    def typed_id(self, items):
        return str(items[0])

    def var_decl(self, items):
        names = items[0]
        init = items[1] if len(items) > 1 else None
        return VarDecl(names, init)

    def assign(self, items):
        return Assign(items[0], items[1])

    def names(self, items):
        return [str(i) for i in items]

    def if_stmt(self, items):
        return If(items[0], items[1])

    def switch_stmt(self, items):
        expr = items[0]
        cases = [c for c in items[1:] if isinstance(c, Case)]
        default = next((b for b in items[1:] if isinstance(b, Block)), None)
        return Switch(expr, cases, default)

    def case(self, items):
        return Case(items[0], items[1])

    def default(self, items):
        return items[0]

    def for_loop(self, items):
        return ForLoop(items[0], items[1], items[2], items[3])

    def break_(self, items):
        return Break()

    def continue_(self, items):
        return Continue()

    def leave(self, _):
        return Leave()

    def expr_stmt(self, items):
        return ExprStmt(items[0])

    def func_call(self, items):
        name = items[0]
        args = items[1:] if len(items) > 1 else []
        return FuncCall(name, args)

    def literal(self, items):
        val = items[0]
        ann = items[1] if len(items) > 1 else None
        return Literal(val, ann)

    def NAME(self, tok):
        return str(tok)

    def STRING(self, tok):
        return str(tok)

    def HEXNUMBER(self, tok):
        return int(tok, 16)

    def DECIMALNUMBER(self, tok):
        return int(tok)

    def number(self, items):
        return items[0]

    def TRUE(self, tok):
        return True

    def FALSE(self, tok):
        return False


from vyper.venom.basicblock import IRBasicBlock, IRLabel, IRLiteral, IRVariable
from vyper.venom.context import IRContext
from vyper.venom.function import IRFunction


IMMUTABLE_SLOT_SIZE = 32


class YulToVenom:
    def __init__(
        self, is_subobject: bool = False, link_libraries: dict[str, int] | None = None
    ):
        self.ctx = IRContext()
        self._break_target: IRBasicBlock | None = None
        self._continue_target: IRBasicBlock | None = None
        self.subobject_info: dict[str, tuple[str, str]] = {}  # name -> (start_label, end_label)
        self.data_offsets: dict[str, int] = {}  # data section name -> offset
        self.is_subobject = is_subobject
        self.subobject_sizes: dict[str, int] = {}  # name -> bytecode size
        self.subobject_bytecode: dict[str, bytes] = {}  # name -> compiled bytecode
        self.object_name: str | None = None
        self.program_start_label: IRLabel | None = None
        self.program_end_label: IRLabel | None = None
        self._data_labels_in_order: list[str] = []
        self._data_sizes: dict[str, int] = {}
        self.immutable_offsets: dict[str, int] = {}  # Map immutable keys to offsets
        self.next_immutable_offset = 0
        self.link_libraries: dict[str, int] = dict(link_libraries) if link_libraries else {}
        self.used_link_libraries: dict[str, int] = {}
        self.unresolved_link_references: set[str] = set()
        self.object_immutable_usage: dict[str | None, set[str]] = {}
        self.immutable_labels: dict[str, str] = {}
        self.subobject_immutable_sizes: dict[str, int] = {}
        self.subobject_immutable_labels: dict[str, str] = {}
        self.free_memory_base: int | None = None
        self.immutable_storage_slots: dict[str, IRLiteral] = {}

    def _immutable_label_for(self, object_name: str | None = None) -> str:
        """Return the label name used for immutable data of the given object."""
        if object_name is None:
            object_name = self.object_name
        if object_name is None:
            raise ValueError("immutable label requested before object name set")
        label = self.immutable_labels.get(object_name)
        if label is None:
            label = f"{object_name}_immutables"
            self.immutable_labels[object_name] = label
        return label

    def _get_or_allocate_immutable_offset(self, key: str) -> int:
        """Return the byte offset assigned to the immutable key, allocating if needed."""
        if key not in self.immutable_offsets:
            self.immutable_offsets[key] = self.next_immutable_offset
            self.next_immutable_offset += IMMUTABLE_SLOT_SIZE
        return self.immutable_offsets[key]

    def _register_immutable_usage(self, key: str) -> None:
        """Track which immutables each object references for sizing the data section."""
        if self.object_name is not None:
            self.object_immutable_usage.setdefault(self.object_name, set()).add(key)

    @staticmethod
    def _extract_string_literal(arg) -> str:
        if not isinstance(arg, Literal) or not isinstance(arg.value, str):
            raise ValueError(f"expected string literal, got {arg}")
        value = arg.value.strip()
        if value.startswith('"') and value.endswith('"'):
            value = value[1:-1]
        return value

    def _resolve_link_address(self, identifier: str) -> int | None:
        """Resolve a linkersymbol identifier to an address if provided."""
        if not self.link_libraries:
            return None

        normalized = identifier.replace('\\', '/')
        candidates: list[str] = []

        def add_candidate(value: str) -> None:
            if value and value not in candidates:
                candidates.append(value)

        add_candidate(identifier)
        add_candidate(normalized)

        if ':' in normalized:
            path_part, name_part = normalized.rsplit(':', 1)
            add_candidate(path_part)
            add_candidate(name_part)
            filename = path_part.split('/')[-1]
            add_candidate(filename)
            add_candidate(f"{filename}:{name_part}")
        else:
            add_candidate(normalized.split('/')[-1])

        for candidate in candidates:
            if candidate in self.link_libraries:
                return self.link_libraries[candidate]

        return None

    def compile(self, ast_node: YulObject) -> IRContext:
        """
        Compile a list of YulObject or Block AST nodes into a Venom IRContext.
        """
        # Remember object name for handling datasize("<object>")
        self.object_name = ast_node.name

        # Predeclare end label symbol for datasize calculation; define later
        self.program_end_label = IRLabel(f"{self.object_name}_end", True)
        # First, compile all nested objects to bytecode
        for item in ast_node.subobjects:
            if isinstance(item, YulObject):
                # Compile the nested object as a completely independent module
                # This is exactly like compiling a standalone Yul file
                nested_compiler = YulToVenom(link_libraries=self.link_libraries)
                # Share the immutable offsets with nested compiler
                nested_compiler.immutable_offsets = self.immutable_offsets.copy()
                nested_compiler.next_immutable_offset = self.next_immutable_offset
                nested_ctx = nested_compiler.compile(item)
                # Update our immutable offsets from nested compilation
                self.immutable_offsets.update(nested_compiler.immutable_offsets)
                self.next_immutable_offset = max(self.next_immutable_offset, nested_compiler.next_immutable_offset)

                # Merge immutable usage bookkeeping
                for obj_name, keys in nested_compiler.object_immutable_usage.items():
                    self.object_immutable_usage.setdefault(obj_name, set()).update(keys)
                
                # Run full optimization passes on the nested context
                run_passes_on(nested_ctx, VenomOptimizationFlags())

                imm_keys = nested_compiler.object_immutable_usage.get(item.name, set())
                imm_size = 0
                if imm_keys:
                    imm_size = (
                        max(nested_compiler.immutable_offsets[key] for key in imm_keys)
                        + IMMUTABLE_SLOT_SIZE
                    )
                    self.subobject_immutable_sizes[item.name] = imm_size

                # Generate assembly and bytecode with full optimization
                asm = generate_assembly_experimental(nested_ctx)
                embedded_bytecode = getattr(nested_ctx, "embedded_bytecode", None)
                program_end_label_name = getattr(nested_ctx, "program_end_label_name", None)
                asm = inject_embedded_bytecode(asm, embedded_bytecode, program_end_label_name)
                bytecode, _ = generate_bytecode(asm)
                
                # Store the bytecode
                self.subobject_bytecode[item.name] = bytecode
                self.subobject_sizes[item.name] = len(bytecode)

                # Register labels for this subobject
                start_label = f"{item.name}_data"
                self.subobject_info[item.name] = (start_label, None)
                self.used_link_libraries.update(nested_compiler.used_link_libraries)
                self.unresolved_link_references.update(
                    nested_compiler.unresolved_link_references
                )

        # Pre-register embedded data so datasize("<object>") can use it
        if self.subobject_bytecode and not self.is_subobject:
            if not hasattr(self.ctx, 'embedded_bytecode'):
                self.ctx.embedded_bytecode = {}
            for name, bytecode in self.subobject_bytecode.items():
                label = f"{name}_data"
                if label not in self.ctx.embedded_bytecode:
                    self.ctx.embedded_bytecode[label] = bytecode
                    self._data_labels_in_order.append(label)
                    self._data_sizes[label] = len(bytecode)
        
        # Gather all function definitions in the AST
        self.functions = {}

        for stmt in ast_node.code.block.statements:
            if isinstance(stmt, FunctionDef):
                self.functions[stmt.name] = stmt

        assert "__global" not in self.functions
        fn = self.ctx.create_function("__global")
        self.program_start_label = fn.entry.label
        self.ctx.entry_function = fn
        for stmt in ast_node.code.block.statements:
            if isinstance(stmt, FunctionDef):
                continue
            self._compile_statement(stmt, fn)
        
        bb = fn.get_basic_block()
        if not bb.is_terminated:
            bb.append_instruction("stop")
        
        # Ensure all basic blocks in main function are terminated
        for bb in fn.get_basic_blocks():
            if not bb.is_terminated:
                bb.append_instruction("stop")

        # Compile each function as a separate Venom function
        for fdef in self.functions.values():
            # Skip if function already exists
            if fdef.name not in [fn.name.value for fn in self.ctx.functions.values()]:
                self._compile_function(fdef)
        
        # Embed subobject bytecode as data (only for main object)
        if self.subobject_bytecode and not self.is_subobject:
            self._embed_subobject_bytecode(fn)

        # Add revert handler near the end
        self._add_revert_handler(fn)

        # Expose program end label name on the context for assembly stage
        # (we will place the label after data section emission)
        if not self.is_subobject:
            setattr(self.ctx, "program_end_label_name", self.program_end_label.value)

        return self.ctx
    
    def _embed_subobject_bytecode(self, fn: IRFunction) -> None:
        """Embed compiled subobject bytecode as data in the IR context."""
        # Store the bytecode in the context for later assembly generation
        if not hasattr(self.ctx, 'embedded_bytecode'):
            self.ctx.embedded_bytecode = {}
        
        for name, bytecode in self.subobject_bytecode.items():
            # Store bytecode for assembly generation
            data_label = f"{name}_data"
            self.ctx.embedded_bytecode[data_label] = bytecode
            self._data_labels_in_order.append(data_label)
            self._data_sizes[data_label] = len(bytecode)
            
            # Create a data block in Venom IR to show the bytecode
            # This will be visible in --venom output
            data_fn = self.ctx.create_function(data_label)
            data_bb = data_fn.entry
            
            # Store the actual bytecode on the function for display
            data_fn.runtime_bytecode = bytecode
            
            # Mark this function as data-only so it can be skipped during assembly
            data_fn.is_data_section = True
            
            # Just terminate the block - it won't be compiled to assembly
            data_bb.append_instruction("stop")
    
    def _compile_subobject_as_function(self, obj: YulObject) -> None:
        """Compile a subobject as a Venom function with start/end labels for size calculation."""
        end_label = f"{obj.name}_end"
        
        # Create a function for the subobject's main code (this serves as the start label)
        fn = self.ctx.create_function(obj.name)
        bb = fn.entry
        bb.is_pinned = True  # Mark as pinned so it's included in assembly
        
        # Save current state
        old_functions = getattr(self, 'functions', {})
        old_function = getattr(self, 'function', None)
        old_fdef = getattr(self, 'current_fdef', None)
        
        self.functions = {}
        self.function = fn
        self.current_fdef = None
        
        # Gather functions from the subobject
        for stmt in obj.code.block.statements:
            if isinstance(stmt, FunctionDef):
                self.functions[stmt.name] = stmt
        
        # Compile the main code of the subobject into main_bb
        for stmt in obj.code.block.statements:
            if isinstance(stmt, FunctionDef):
                continue
            self._compile_statement(stmt, fn)
        
        # Ensure it terminates
        current_bb = fn.get_basic_block()
        if not current_bb.is_terminated:
            current_bb.append_instruction("stop")
        
        # Compile subobject's functions as separate Venom functions
        for fdef in self.functions.values():
            if fdef.name not in [fn.name.value for fn in self.ctx.functions.values()]:
                self._compile_function(fdef)
        
        # Create the end label as a function
        end_fn = self.ctx.create_function(end_label)
        end_bb = end_fn.entry
        end_bb.is_pinned = True  # Mark as pinned to avoid optimization issues
        end_bb.append_instruction("stop")
        
        # Restore state
        self.functions = old_functions
        self.function = old_function
        self.current_fdef = old_fdef
    
    def _add_revert_handler(self, fn: IRFunction) -> None:
        revert_label = IRLabel("revert")
        revert_bb = IRBasicBlock(revert_label, fn)
        revert_bb.is_pinned = True  # Make sure this block gets emitted
        revert_bb.append_instruction("revert", IRLiteral(0), IRLiteral(0))
        fn.append_basic_block(revert_bb)

    def _compile_function(self, fdef: FunctionDef) -> IRFunction:
        # Create IRFunction
        fn = self.ctx.create_function(fdef.name)
        bb = fn.entry

        self.current_fdef = fdef

        # Parameters
        for pname in fdef.params:
            var = IRVariable(pname)
            bb.append_instruction("param", ret=var)

        self.return_pc = bb.append_instruction("param")
        self.return_pc.annotation = "return_pc"

        self.function = fn

        # Compile body
        self._compile_block(fdef.body, fn)

        # Implicit return
        last_bb = fn.get_basic_block()
        if not last_bb.is_terminated:
            self._compile_leave()
        
        # Ensure all basic blocks are terminated
        for bb in fn.get_basic_blocks():
            if not bb.is_terminated:
                # Add a stop instruction to unterminated blocks
                # These are typically unreachable blocks
                bb.append_instruction("stop")

        return fn
    
    def _compile_function_as_blocks(self, fdef: FunctionDef, fn: IRFunction) -> None:
        func_label = IRLabel(fdef.name)
        func_bb = IRBasicBlock(func_label, fn)
        fn.append_basic_block(func_bb)
        
        # Save current state
        old_fdef = getattr(self, 'current_fdef', None)
        old_return_pc = getattr(self, 'return_pc', None)
        
        self.current_fdef = fdef
        self.function = fn
        
        # Handle parameters - they come in as %1, %2, etc from invoke
        for i, pname in enumerate(fdef.params):
            var = IRVariable(pname)
            func_bb.append_instruction("param", ret=var)
        
        # Get return address
        self.return_pc = func_bb.append_instruction("param")
        self.return_pc.annotation = "return_pc"
        
        # Compile function body
        self._compile_block(fdef.body, fn)
        
        # Add implicit return if needed
        last_bb = fn.get_basic_block()
        if not last_bb.is_terminated:
            self._compile_leave()
        
        # Restore state
        self.current_fdef = old_fdef
        self.return_pc = old_return_pc

    def _compile_leave(self):
        fdef = self.current_fdef
        fn = self.function
        bb = fn.get_basic_block()

        if not bb.is_terminated:
            # Return with the return values
            return_args = [IRVariable(s) for s in fdef.returns]
            bb.append_instruction("ret", *return_args, self.return_pc)

    def _compile_block(self, block: Block, fn: IRFunction) -> None:
        for stmt in block.statements:
            self._compile_statement(stmt, fn)

    def _compile_statement(self, stmt, fn: IRFunction) -> None:
        bb = fn.get_basic_block()

        if isinstance(stmt, VarDecl):
            if stmt.init:
                # Check if this is an ABI decode pattern we can optimize
                if (
                    isinstance(stmt.init, FuncCall)
                    and stmt.init.name.startswith("abi_decode_tuple_t_")
                    and self._try_optimize_abi_decode(stmt, bb)
                ):
                    # Successfully optimized - skip normal processing
                    pass
                else:
                    val = self._compile_expr(stmt.init, bb)
                    if len(stmt.names) > 1:
                        # Multiple variable declaration - Yul allows this for functions with multiple returns
                        if isinstance(val, list):
                            # Function returned multiple values - unpack them
                            for i, name in enumerate(stmt.names):
                                if i < len(val):
                                    bb.append_instruction("assign", val[i], ret=IRVariable(name))
                                else:
                                    # If fewer returns than names, zero-initialize the rest
                                    bb.append_instruction("assign", IRLiteral(0), ret=IRVariable(name))
                        else:
                            # Single value returned but multiple variables declared
                            # Assign to first, zero-initialize the rest (fallback behavior)
                            bb.append_instruction("assign", val, ret=IRVariable(stmt.names[0]))
                            for name in stmt.names[1:]:
                                bb.append_instruction("assign", IRLiteral(0), ret=IRVariable(name))
                    else:
                        # Single variable declaration
                        if isinstance(val, list):
                            # Function returned multiple values but we only need one
                            bb.append_instruction("assign", val[0] if val else IRLiteral(0), ret=IRVariable(stmt.names[0]))
                        else:
                            bb.append_instruction("assign", val, ret=IRVariable(stmt.names[0]))
            else:
                # uninitialized variables default to 0 in Yul
                for name in stmt.names:
                    bb.append_instruction("assign", IRLiteral(0), ret=IRVariable(name))

        elif isinstance(stmt, Assign):
            val = self._compile_expr(stmt.value, bb)
            if len(stmt.targets) > 1:
                # Multiple assignment - handle multi-return functions
                if isinstance(val, list):
                    # Function returned multiple values - unpack them
                    for i, target in enumerate(stmt.targets):
                        if i < len(val):
                            bb.append_instruction("assign", val[i], ret=IRVariable(target))
                        else:
                            # If fewer returns than targets, zero-initialize the rest
                            bb.append_instruction("assign", IRLiteral(0), ret=IRVariable(target))
                else:
                    # Single value returned but multiple targets
                    # Assign to first, zero-initialize the rest
                    bb.append_instruction("assign", val, ret=IRVariable(stmt.targets[0]))
                    for target in stmt.targets[1:]:
                        bb.append_instruction("assign", IRLiteral(0), ret=IRVariable(target))
            else:
                # Single target
                if isinstance(val, list):
                    # Function returned multiple values but we only need one
                    bb.append_instruction("assign", val[0] if val else IRLiteral(0), ret=IRVariable(stmt.targets[0]))
                else:
                    bb.append_instruction("assign", val, ret=IRVariable(stmt.targets[0]))

        elif isinstance(stmt, ExprStmt):
            self._compile_expr(stmt.expr, bb)

        elif isinstance(stmt, If):
            cond_op = self._compile_expr(stmt.cond, bb)
            then_bb = IRBasicBlock(self.ctx.get_next_label("then"), fn)
            join_bb = IRBasicBlock(self.ctx.get_next_label("join"), fn)

            bb.append_instruction("jnz", cond_op, then_bb.label, join_bb.label)

            fn.append_basic_block(then_bb)
            self._compile_block(stmt.body, fn)
            if not (then_bb := fn.get_basic_block()).is_terminated:
                then_bb.append_instruction("jmp", join_bb.label)

            fn.append_basic_block(join_bb)

        elif isinstance(stmt, Switch):
            expr_op = self._compile_expr(stmt.expr, bb)
            end_bb = IRBasicBlock(self.ctx.get_next_label("switch_end"), fn)
            case_bbs = []
            for case in stmt.cases:
                cb = IRBasicBlock(self.ctx.get_next_label("case"), fn)
                case_bbs.append((case.value.value, cb, case.body))

            default_bb = end_bb
            if stmt.default:
                default_bb = IRBasicBlock(self.ctx.get_next_label("switch_default"), fn)

            # Chain comparisons
            curr_bb = bb
            for idx, (val, cb, body) in enumerate(case_bbs):
                cmp_op = curr_bb.append_instruction("eq", expr_op, IRLiteral(val))
                next_bb = (
                    default_bb
                    if idx == len(case_bbs) - 1
                    else IRBasicBlock(self.ctx.get_next_label("switch_next"), fn)
                )
                if next_bb is not default_bb:
                    fn.append_basic_block(next_bb)
                curr_bb.append_instruction("jnz", cmp_op, cb.label, next_bb.label)
                curr_bb = next_bb

            # Compile case bodies
            for val, cb, body in case_bbs:
                fn.append_basic_block(cb)
                self._compile_block(body, fn)
                if not cb.is_terminated:
                    cb.append_instruction("jmp", end_bb.label)

            # Default body
            if stmt.default:
                fn.append_basic_block(default_bb)
                self._compile_block(stmt.default, fn)
                if not default_bb.is_terminated:
                    default_bb.append_instruction("jmp", end_bb.label)

            fn.append_basic_block(end_bb)
            # The end block might be unreachable if all cases terminate
            # We'll handle this after all statements are compiled

        elif isinstance(stmt, ForLoop):
            # init
            self._compile_block(stmt.init, fn)
            cond_bb = IRBasicBlock(self.ctx.get_next_label("for_cond"), fn)
            body_bb = IRBasicBlock(self.ctx.get_next_label("for_body"), fn)
            post_bb = IRBasicBlock(self.ctx.get_next_label("for_post"), fn)
            end_bb = IRBasicBlock(self.ctx.get_next_label("for_end"), fn)

            fn.get_basic_block().append_instruction("jmp", cond_bb.label)
            fn.append_basic_block(cond_bb)
            cond_op = self._compile_expr(stmt.cond, cond_bb)
            cond_bb.append_instruction("jnz", cond_op, body_bb.label, end_bb.label)

            old_break, old_continue = self._break_target, self._continue_target
            self._break_target, self._continue_target = end_bb, post_bb

            fn.append_basic_block(body_bb)
            self._compile_block(stmt.body, fn)
            body_bb = fn.get_basic_block()
            if not body_bb.is_terminated:
                body_bb.append_instruction("jmp", post_bb.label)

            fn.append_basic_block(post_bb)
            self._compile_block(stmt.post, fn)
            post_bb.append_instruction("jmp", cond_bb.label)

            self._break_target, self._continue_target = old_break, old_continue

            fn.append_basic_block(end_bb)

        elif isinstance(stmt, Break):
            assert self._break_target is not None
            bb.append_instruction("jmp", self._break_target.label)
            # Create a new basic block for any code after break (though it's unreachable)
            unreachable_bb = IRBasicBlock(self.ctx.get_next_label("unreachable"), fn)
            fn.append_basic_block(unreachable_bb)

        elif isinstance(stmt, Continue):
            assert self._continue_target is not None
            bb.append_instruction("jmp", self._continue_target.label)
            # Create a new basic block for any code after continue (though it's unreachable)
            unreachable_bb = IRBasicBlock(self.ctx.get_next_label("unreachable"), fn)
            fn.append_basic_block(unreachable_bb)

        elif isinstance(stmt, Leave):
            self._compile_leave()

        elif isinstance(stmt, Block):
            self._compile_block(stmt, fn)

        elif isinstance(stmt, FunctionDef):
            # Handle nested function definitions!
            self._compile_function(stmt)

        else:
            raise NotImplementedError(f"Statement {type(stmt)} not implemented: {stmt}")

    def _string_to_evm_value(self, s: str) -> int:
        if s.startswith('"') and s.endswith('"'):
            s = s[1:-1]

        b = s.encode('utf-8')

        # Truncate to 32 bytes for now
        if len(b) > 32:
            b = b[:32]

        padded = b.ljust(32, b'\x00')
        return int.from_bytes(padded, 'big')

    def _try_optimize_abi_decode(self, stmt: VarDecl, bb: IRBasicBlock) -> bool:
        """
        Try to optimize ABI decode patterns by inlining them.

        Returns True if optimization was applied, False otherwise.
        """
        if not isinstance(stmt.init, FuncCall):
            return False

        func_name = stmt.init.name
        num_returns = len(stmt.names)

        parse_result = parse_abi_decode_pattern(func_name)
        if not parse_result:
            return False

        types, is_memory = parse_result

        if len(types) != num_returns:
            return False

        # For now, only optimize simple patterns with 1-4 parameters
        if num_returns < 1 or num_returns > 4:
            return False

        # Only handle simple scalar types that can fit in a single word
        supported_scalar_types = {
            "uint256",
            "uint128",
            "uint64",
            "uint32",
            "uint16",
            "uint8",
            "int256",
            "int128",
            "int64",
            "int32",
            "int16",
            "int8",
            "address",
            "bool",
            "bytes32",
            "bytes16",
            "bytes8",
            "bytes4",
        }

        if any(t not in supported_scalar_types for t in types):
            return False

        # Check if we have the expected offset argument (headStart)
        if len(stmt.init.args) < 1:
            return False

        offset_operand = self._compile_expr(stmt.init.args[0], bb)
        offset_values = self._flatten_operands([offset_operand])
        if len(offset_values) != 1:
            return False
        base_offset = offset_values[0]

        signextend_indices = {
            "int8": 0,
            "int16": 1,
            "int32": 3,
            "int64": 7,
            "int128": 15,
        }

        # Generate optimized loads for each parameter
        for i, (name, type_name) in enumerate(zip(stmt.names, types)):
            current_offset = base_offset
            if i > 0:
                current_offset = bb.append_instruction("add", base_offset, IRLiteral(32 * i))

            # Load the word from calldata or memory
            load_op = get_load_instruction_for_type(type_name, is_memory)
            value = bb.append_instruction(load_op, current_offset)

            # Apply masking if required (e.g. address, bytes4)
            mask_value = get_type_mask(type_name)
            if mask_value is not None:
                value = bb.append_instruction("and", value, IRLiteral(mask_value))

            # Handle special post-processing such as booleans or signed ints
            special_handling = needs_special_handling(type_name)
            if special_handling == "bool":
                value = bb.append_instruction("iszero", value)
                value = bb.append_instruction("iszero", value)
            elif special_handling == "signext":
                signextend_index = signextend_indices.get(type_name)
                if signextend_index is None:
                    return False
                value = bb.append_instruction("signextend", IRLiteral(signextend_index), value)

            bb.append_instruction("assign", value, ret=IRVariable(name))

        return True

    def _flatten_operands(
        self, operands: Iterable[IRLiteral | IRVariable | IRLabel | list]
    ) -> list[IRLiteral | IRVariable | IRLabel]:
        """Recursively flatten operand lists produced by multi-return invocations."""

        flat: list[IRLiteral | IRVariable | IRLabel] = []
        for operand in operands:
            if isinstance(operand, list):
                flat.extend(self._flatten_operands(operand))
            else:
                flat.append(operand)
        return flat

    def _get_immutable_storage_slot(self, key: str) -> IRLiteral:
        """Derive a deterministic storage slot for an immutable identifier."""
        slot = self.immutable_storage_slots.get(key)
        if slot is None:
            slot_bytes = keccak(text=key)
            slot_value = int.from_bytes(slot_bytes, "big")
            slot = IRLiteral(slot_value)
            self.immutable_storage_slots[key] = slot
        return slot

    def _compile_setimmutable(self, expr: FuncCall, bb: IRBasicBlock) -> IRLiteral:
        if len(expr.args) != 3:
            raise ValueError(f"setimmutable expects 3 arguments, got {len(expr.args)}")

        _ = self._compile_expr(expr.args[0], bb)  # evaluate pointer for side effects if any
        key = self._extract_string_literal(expr.args[1])
        value_operand = self._compile_expr(expr.args[2], bb)

        self._get_or_allocate_immutable_offset(key)
        slot_literal = self._get_immutable_storage_slot(key)

        value_flat = self._flatten_operands([value_operand])
        if len(value_flat) != 1:
            raise ValueError("setimmutable value must resolve to single operand")
        value_final = value_flat[0]

        bb.append_instruction("sstore", value_final, slot_literal)
        return IRLiteral(0)

    def _compile_loadimmutable(self, expr: FuncCall, bb: IRBasicBlock):
        if len(expr.args) != 1:
            raise ValueError(f"loadimmutable expects 1 argument, got {len(expr.args)}")

        key = self._extract_string_literal(expr.args[0])
        self._get_or_allocate_immutable_offset(key)
        slot_literal = self._get_immutable_storage_slot(key)
        return bb.append_instruction("sload", slot_literal)

    def _compile_expr(
        self, expr, bb: IRBasicBlock
    ) -> IRVariable | IRLiteral | IRLabel | list[IRVariable | IRLiteral | IRLabel]:
        if isinstance(expr, Literal):
            # Handle string literals by converting to EVM representation
            if isinstance(expr.value, str):
                # String literals are passed with quotes from the parser
                return IRLiteral(self._string_to_evm_value(expr.value))
            return IRLiteral(expr.value)
        if isinstance(expr, str):
            return IRVariable(expr)
        if isinstance(expr, FuncCall):
            if expr.name == "setimmutable":
                return self._compile_setimmutable(expr, bb)
            if expr.name == "loadimmutable":
                return self._compile_loadimmutable(expr, bb)
            if expr.name == "memoryguard":
                guard_operand = (
                    self._compile_expr(expr.args[0], bb) if expr.args else IRLiteral(0)
                )
                if isinstance(guard_operand, IRLiteral):
                    guard_val = guard_operand.value
                    if not isinstance(guard_val, int):
                        raise ValueError("memoryguard expects integer literal")
                    if self.free_memory_base is None or guard_val > self.free_memory_base:
                        self.free_memory_base = guard_val
                return guard_operand

            compiled_args_forward = [self._compile_expr(arg, bb) for arg in expr.args]
            args = list(reversed(compiled_args_forward))

            # Note: ABI decode optimization is now handled in _try_optimize_abi_decode
            # This path is kept for backwards compatibility but should be removed
            # once we verify the new optimization works correctly

            if expr.name in self.functions:
                target_func = self.functions[expr.name]
                target_label = IRLabel(expr.name)
                num_returns = len(target_func.returns)
                # Pass 1 for single returns (backwards compatible), actual count for multi-returns
                returns_param = 1 if num_returns == 1 else num_returns if num_returns > 1 else False
                invoke_args = [target_label, *self._flatten_operands(compiled_args_forward)]
                return bb.append_invoke_instruction(invoke_args, returns=returns_param)
            else:
                # Handle dataoffset and datasize specially
                if expr.name == "dataoffset" and len(expr.args) == 1:
                    arg_expr = expr.args[0]
                    if isinstance(arg_expr, Literal) and isinstance(arg_expr.value, str):
                        arg_name = arg_expr.value.strip('"')
                        # For pre-compiled subobjects, return the data label
                        if arg_name in self.subobject_bytecode:
                            return IRLabel(f"{arg_name}_data")
                        # Fallback for other data sections
                        return IRLabel(arg_name)
                    return IRLiteral(0)
                
                elif expr.name == "datasize" and len(expr.args) == 1:
                    arg_expr = expr.args[0]
                    if isinstance(arg_expr, Literal) and isinstance(arg_expr.value, str):
                        arg_name = arg_expr.value.strip('"')
                        # 1) Pre-compiled subobject size (embedded runtime)
                        if arg_name in self.subobject_sizes:
                            return IRLiteral(self.subobject_sizes[arg_name])
                        # 2) Object-wide program size: compute end-start using label offsets
                        if self.object_name is not None and arg_name == self.object_name:
                            # Use program-end label resolved by assembler
                            assert self.program_end_label is not None
                            return bb.append_instruction("offset", IRLiteral(0), self.program_end_label)
                        # 3) Unknown sections default to zero
                        return IRLiteral(0)
                
                # Handle immutable operations
                elif expr.name == "linkersymbol":
                    if len(expr.args) != 1:
                        raise Exception(f"linkersymbol expects 1 argument, got {len(expr.args)}")

                    arg_expr = expr.args[0]
                    if not isinstance(arg_expr, Literal) or not isinstance(arg_expr.value, str):
                        raise Exception(f"linkersymbol expects a string literal, got {arg_expr}")

                    identifier = arg_expr.value.strip()
                    if identifier.startswith('"') and identifier.endswith('"'):
                        identifier = identifier[1:-1]

                    resolved_address = self._resolve_link_address(identifier)
                    if resolved_address is not None:
                        self.used_link_libraries[identifier] = resolved_address
                        return IRLiteral(resolved_address)

                    self.unresolved_link_references.add(identifier)
                    return IRLiteral(0)

                # regular evm instruction
                # special mappings: log1, log2.. -> log 1, log 2, ...
                opcode = expr.name
                if opcode.startswith("log"):
                    topic_count = int(opcode[3:])
                    return bb.append_instruction(
                        "log", topic_count, *self._flatten_operands(args)
                    )

                if opcode == "keccak256":
                    # vyper calls it sha3 internally
                    opcode = "sha3"

                if opcode == "memoryguard":
                    # memoryguard reserves memory.. we could maybe
                    # call this 'reserve' (or reuse alloc)
                    opcode = "assign"

                result = bb.append_instruction(opcode, *self._flatten_operands(args))

                return result

        raise NotImplementedError(f"Expr {type(expr)} not implemented: {expr}")


def compile_to_venom(
    ast_nodes: YulObject, link_libraries: dict[str, int] | None = None
) -> IRContext:
    builder = YulToVenom(link_libraries=link_libraries)
    ctx = builder.compile(ast_nodes)
    
    # If there's embedded bytecode, we need to handle it specially
    # during assembly generation
    if hasattr(ctx, 'embedded_bytecode'):
        # Store the embedded bytecode info for the assembly generator
        ctx.has_embedded_data = True
    
    ctx.used_link_libraries = dict(builder.used_link_libraries)
    ctx.unresolved_link_references = set(builder.unresolved_link_references)

    return ctx


if __name__ == "__main__":
    _parse_args(sys.argv[1:])
