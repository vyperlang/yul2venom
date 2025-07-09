#!/usr/bin/env python3
from __future__ import annotations
import argparse
import sys

from lark import Lark

import vyper
import vyper.evm.opcodes as evm
from vyper.compiler.phases import generate_bytecode
from vyper.compiler.settings import OptimizationLevel, Settings, set_global_settings
from vyper.venom import generate_assembly_experimental, run_passes_on
from vyper.venom.basicblock import IRBasicBlock, IRLabel, IRLiteral, IRVariable, IRHexString
from vyper.venom.check_venom import check_venom_ctx
from vyper.venom.context import IRContext
from vyper.venom.function import IRFunction
from vyper.venom.parser import parse_venom

"""
Standalone entry point into venom compiler. Parses venom input and emits
bytecode.
"""


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

    args = parser.parse_args(argv)

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
    if isinstance(ast, list) and len(ast) > 0:
        ast = ast[0]
    ctx = compile_to_venom(ast)

    # check_venom_ctx(ctx)  # Skip check for now to see output

    if args.venom:
        print(ctx)
        return

    run_passes_on(ctx, OptimizationLevel.GAS)
    
    if args.asm:
        asm = generate_assembly_experimental(ctx, OptimizationLevel.NONE)
        print(asm)
        return
        
    asm = generate_assembly_experimental(ctx)
    bytecode, _ = generate_bytecode(asm)
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
from typing import List, Optional, Union

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


from vyper.venom.basicblock import IRBasicBlock, IRLabel, IRLiteral, IRVariable, IRHexString
from vyper.venom.context import IRContext
from vyper.venom.function import IRFunction


class YulToVenom:
    def __init__(self, is_subobject: bool = False):
        self.ctx = IRContext()
        self._break_target: IRBasicBlock | None = None
        self._continue_target: IRBasicBlock | None = None
        self.subobject_info: dict[str, tuple[str, str]] = {}  # name -> (start_label, end_label)
        self.data_offsets: dict[str, int] = {}  # data section name -> offset
        self.is_subobject = is_subobject
        self.subobject_sizes: dict[str, int] = {}  # name -> bytecode size

    def compile(self, ast_node: YulObject) -> IRContext:
        """
        Compile a list of YulObject or Block AST nodes into a Venom IRContext.
        """
        # First, register all subobjects and create const expressions
        for item in ast_node.subobjects:
            if isinstance(item, YulObject):
                start_label = item.name  # Use the object name directly as start
                end_label = f"{item.name}_end"
                self.subobject_info[item.name] = (start_label, end_label)
                
                # Add const expression for size calculation as a tuple
                size_name = f"{item.name.upper()}_SIZE"
                self.ctx.add_const_expression(size_name, ("sub", f"@{end_label}", f"@{start_label}"))
        
        # Gather all function definitions in the AST
        self.functions = {}

        for stmt in ast_node.code.block.statements:
            if isinstance(stmt, FunctionDef):
                self.functions[stmt.name] = stmt

        assert "__global" not in self.functions
        fn = self.ctx.create_function("__global")
        self.ctx.entry_function = fn
        
        # Add a revert handler for assert
        self._add_revert_handler(fn)
        
        for stmt in ast_node.code.block.statements:
            if isinstance(stmt, FunctionDef):
                continue
            self._compile_statement(stmt, fn)
        
        bb = fn.get_basic_block()
        if not bb.is_terminated:
            bb.append_instruction("stop")

        # Compile each function as a separate Venom function
        for fdef in self.functions.values():
            # Skip if function already exists
            if fdef.name not in [fn.name.value for fn in self.ctx.functions.values()]:
                self._compile_function(fdef)
        
        # Inline subobject code after main code (only for main object)
        if ast_node.subobjects and not self.is_subobject:
            self._inline_subobjects(ast_node)

        return self.ctx
    
    def _inline_subobjects(self, ast_node: YulObject) -> None:
        """Compile subobjects as separate functions in the same context."""
        for item in ast_node.subobjects:
            if isinstance(item, YulObject):
                # Compile the subobject as a function named after it
                self._compile_subobject_as_function(item)
    
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
        entry_bb = fn.get_basic_block()
        
        continue_label = self.ctx.get_next_label("main_continue")
        continue_bb = IRBasicBlock(continue_label, fn)
        
        entry_bb.append_instruction("jmp", continue_label)
        
        revert_label = IRLabel("revert")
        revert_bb = IRBasicBlock(revert_label, fn)
        revert_bb.is_pinned = True  # Make sure this block gets emitted
        fn.append_basic_block(revert_bb)
        
        revert_bb.append_instruction("revert", IRLiteral(0), IRLiteral(0))
        
        fn.append_basic_block(continue_bb)

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
                val = self._compile_expr(stmt.init, bb)
                bb.append_instruction("store", val, ret=IRVariable(stmt.names[0]))

        elif isinstance(stmt, Assign):
            val = self._compile_expr(stmt.value, bb)
            bb.append_instruction("store", val, ret=IRVariable(stmt.targets[0]))

        elif isinstance(stmt, ExprStmt):
            self._compile_expr(stmt.expr, bb)

        elif isinstance(stmt, If):
            cond_op = self._compile_expr(stmt.cond, bb)
            then_bb = IRBasicBlock(self.ctx.get_next_label("then"), fn)
            else_bb = IRBasicBlock(self.ctx.get_next_label("else"), fn)
            join_bb = IRBasicBlock(self.ctx.get_next_label("join"), fn)

            bb.append_instruction("jnz", cond_op, then_bb.label, else_bb.label)

            fn.append_basic_block(then_bb)
            self._compile_block(stmt.body, fn)
            if not (then_bb := fn.get_basic_block()).is_terminated:
                then_bb.append_instruction("jmp", join_bb.label)

            fn.append_basic_block(else_bb)
            if not (else_bb := fn.get_basic_block()).is_terminated:
                else_bb.append_instruction("jmp", join_bb.label)

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
            #fn.append_basic_block(IRBasicBlock(self.ctx.get_next_label(), fn))

        elif isinstance(stmt, Continue):
            assert self._continue_target is not None
            bb.append_instruction("jmp", self._continue_target.label)
            #fn.append_basic_block(IRBasicBlock(self.ctx.get_next_label(), fn))

        elif isinstance(stmt, Leave):
            self._compile_leave()

        elif isinstance(stmt, Block):
            self._compile_block(stmt, fn)

        else:
            raise NotImplementedError(f"Statement {type(stmt)} not implemented: {stmt}")

    def _compile_expr(self, expr, bb: IRBasicBlock) -> IRVariable | IRLiteral:
        if isinstance(expr, Literal):
            # For string literals, return the string value itself
            if isinstance(expr.value, str):
                return expr.value
            return IRLiteral(expr.value)
        if isinstance(expr, str):
            return IRVariable(expr)
        if isinstance(expr, FuncCall):
            args = [self._compile_expr(arg, bb) for arg in reversed(expr.args)]

            if expr.name in self.functions:
                target_func = self.functions[expr.name]
                target_label = IRLabel(expr.name)
                has_return = len(target_func.returns) > 0
                return bb.append_invoke_instruction([target_label, *args], returns=has_return)
            else:
                # Handle dataoffset and datasize specially
                if expr.name == "dataoffset" and len(expr.args) == 1:
                    arg_expr = expr.args[0]
                    if isinstance(arg_expr, Literal) and isinstance(arg_expr.value, str):
                        arg_name = arg_expr.value.strip('"')
                        # For subobjects, return the object name directly as the label
                        # Use is_symbol=False to ensure it's treated as a regular label, not a const
                        return IRLabel(arg_name, is_symbol=False)
                    return IRLiteral(0)
                
                elif expr.name == "datasize" and len(expr.args) == 1:
                    arg_expr = expr.args[0]
                    if isinstance(arg_expr, Literal) and isinstance(arg_expr.value, str):
                        arg_name = arg_expr.value.strip('"')
                        # Return a placeholder label that will be resolved later
                        size_name = f"{arg_name.upper()}_SIZE"
                        # Use IRLabel with is_symbol=True to indicate it's a const reference
                        return IRLabel(f"${size_name}", is_symbol=True)
                    return IRLiteral(0)
                
                # regular evm instruction
                # special mappings: log1, log2.. -> log 1, log 2, ...
                opcode = expr.name
                if opcode.startswith("log"):
                    topic_count = int(opcode[3:])
                    return bb.append_instruction("log", topic_count, *args)

                if opcode == "keccak256":
                    # vyper calls it sha3 internally
                    opcode = "sha3"

                if opcode == "memoryguard":
                    # memoryguard reserves memory.. we could maybe
                    # call this 'reserve' (or reuse alloc)
                    opcode = "store"
                return bb.append_instruction(opcode, *args)

        raise NotImplementedError(f"Expr {type(expr)} not implemented: {expr}")


def compile_to_venom(ast_nodes: YulObject) -> IRContext:
    builder = YulToVenom()
    return builder.compile(ast_nodes)


if __name__ == "__main__":
    _parse_args(sys.argv[1:])
