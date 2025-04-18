#!/usr/bin/env python3
import argparse
import sys

from lark import Lark

import vyper
import vyper.evm.opcodes as evm
from vyper.compiler.phases import generate_bytecode
from vyper.compiler.settings import OptimizationLevel, Settings, set_global_settings
from vyper.venom import generate_assembly_experimental, run_passes_on
from vyper.venom.basicblock import IRBasicBlock, IRLabel, IRLiteral, IRVariable
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
    ctx = compile_to_venom(ast)

    run_passes_on(ctx, OptimizationLevel.GAS)
    asm = generate_assembly_experimental(ctx)
    bytecode = generate_bytecode(asm, compiler_metadata=None)
    print(f"0x{bytecode.hex()}")


yul_grammar = r"""
%import common.WS
%import common.ESCAPED_STRING -> STRING
%import common.CNAME -> NAME
%ignore WS
%ignore /\/\/[^\n]*/
%ignore /\/\*(.|\n)*?\*\//

HEXNUMBER: /0x[0-9a-fA-F]+/
DECIMALNUMBER: /\d+/
number: HEXNUMBER | DECIMALNUMBER
TRUE: "true"
FALSE: "false"

?start: (object | block)+

object: "object" STRING "{" code_section (object | data_section)* "}"
code_section: "code" block
data_section: "data" STRING (HEXNUMBER | STRING)

block: "{" statement* "}"
?statement: block
           | function_def
           | var_decl
           | assign
           | if_stmt
           | switch_stmt
           | for_loop
           | break_con
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
break_con: "break" | "continue"
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
    code: "CodeSection"
    subobjects: List[Union["YulObject", "DataSection"]] = field(default_factory=list)


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

    def break_con(self, items):
        return Break() if items[0] == "break" else Continue()

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


class YulToVenom:
    def __init__(self):
        self.ctx = IRContext()
        self._break_target: IRBasicBlock | None = None
        self._continue_target: IRBasicBlock | None = None

    def compile(self, ast_node: YulObject) -> IRContext:
        """
        Compile a list of YulObject or Block AST nodes into a Venom IRContext.
        """
        # Gather all function definitions in the AST
        functions: list[FunctionDef] = []
        functions.extend(self._collect_functions(ast_node))
        self.functions = {f.name: f for f in functions}

        fn = self.ctx.create_function("__global")
        self.ctx.entry_function = fn
        for stmt in ast_node.code.block.statements:
            if isinstance(stmt, FunctionDef):
                continue
            self._compile_statement(stmt, fn)
        fn.get_basic_block().append_instruction("stop")  # invalid?

        # Compile each function
        for fdef in functions:
            self._compile_function(fdef)
        return self.ctx

    def _collect_functions(self, node) -> list[FunctionDef]:
        funcs: list[FunctionDef] = []
        if isinstance(node, FunctionDef):
            funcs.append(node)
        # Recurse into child nodes
        if isinstance(node, YulObject):
            for stmt in node.code.block.statements:
                funcs.extend(self._collect_functions(stmt))
            for sub in getattr(node, "subobjects", []):
                funcs.extend(self._collect_functions(sub))
        elif isinstance(node, Block):
            for stmt in node.statements:
                funcs.extend(self._collect_functions(stmt))
        elif isinstance(node, If):
            funcs.extend(self._collect_functions(node.body))
        elif isinstance(node, Switch):
            funcs.extend(self._collect_functions(node.expr))
            for case in node.cases:
                funcs.extend(self._collect_functions(case.body))
            if node.default:
                funcs.extend(self._collect_functions(node.default))
        elif isinstance(node, ForLoop):
            funcs.extend(self._collect_functions(node.init))
            funcs.extend(self._collect_functions(node.post))
            funcs.extend(self._collect_functions(node.body))
        # Other nodes do not contain FunctionDef
        return funcs

    def _compile_function(self, fdef: FunctionDef) -> IRFunction:
        # Create IRFunction
        fn = self.ctx.create_function(fdef.name)
        bb = fn.entry

        self.current_fdef = fdef

        # Parameters
        for pname in fdef.params:
            var = IRVariable(pname)
            bb.append_instruction("param", ret=var)
            fn.args.append(var)

        self.return_pc = bb.append_instruction("param", annotation="return_pc")
        self.function = fn

        # Compile body
        self._compile_block(fdef.body, fn)

        # Implicit return
        last_bb = fn.get_basic_block()
        if not last_bb.is_terminated:
            self._compile_leave()

        return fn

    def _compile_leave(self):
        fdef = self.current_fdef
        fn = self.function
        return_args = [IRVariable(s) for s in fdef.returns]
        return_pc = self.return_pc

        bb = fn.get_basic_block()
        bb.append_instruction("ret", *return_args, return_pc)

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
            end_bb = IRBasicBlock(self.ctx.get_next_label("ifend"), fn)

            bb.append_instruction("jnz", cond_op, then_bb.label, else_bb.label)

            fn.append_basic_block(then_bb)
            self._compile_block(stmt.body, fn)
            if not then_bb.is_terminated:
                then_bb.append_instruction("jmp", end_bb.label)

            fn.append_basic_block(else_bb)
            if not else_bb.is_terminated:
                else_bb.append_instruction("jmp", end_bb.label)

            fn.append_basic_block(end_bb)

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
            fn.append_basic_block(cond_bb)
            fn.append_basic_block(body_bb)
            fn.append_basic_block(post_bb)
            fn.append_basic_block(end_bb)

            bb.append_instruction("jmp", cond_bb.label)
            cond_op = self._compile_expr(stmt.cond, cond_bb)
            cond_bb.append_instruction("jnz", cond_op, body_bb.label, end_bb.label)

            old_break, old_continue = self._break_target, self._continue_target
            self._break_target, self._continue_target = end_bb, post_bb

            fn.append_basic_block(body_bb)
            self._compile_block(stmt.body, fn)
            if not body_bb.is_terminated:
                body_bb.append_instruction("jmp", post_bb.label)

            fn.append_basic_block(post_bb)
            self._compile_block(stmt.post, fn)
            post_bb.append_instruction("jmp", cond_bb.label)

            fn.append_basic_block(end_bb)
            self._break_target, self._continue_target = old_break, old_continue

        elif isinstance(stmt, Break):
            assert self._break_target
            bb.append_instruction("jmp", self._break_target.label)
            fn.append_basic_block(IRBasicBlock(self.ctx.get_next_label(), fn))

        elif isinstance(stmt, Continue):
            assert self._continue_target
            bb.append_instruction("jmp", self._continue_target.label)
            fn.append_basic_block(IRBasicBlock(self.ctx.get_next_label(), fn))

        elif isinstance(stmt, Leave):
            self._compile_leave(fn)

        else:
            raise NotImplementedError(f"Statement {type(stmt)} not implemented: {stmt}")

    def _compile_expr(self, expr, bb: IRBasicBlock) -> IRVariable | IRLiteral:
        if isinstance(expr, Literal):
            return IRLiteral(expr.value)
        if isinstance(expr, str):
            return IRVariable(expr)
        if isinstance(expr, FuncCall):
            args = [self._compile_expr(arg, bb) for arg in expr.args]
            if expr.name in self.functions:
                target_func = self.functions[expr.name]
                target_label = IRLabel(expr.name)
                has_return = bool(target_func.returns)
                return bb.append_invoke_instruction([target_label, *reversed(args)], returns=has_return)
            else:
                # regular evm instruction
                # special mappings: log1, log2.. -> log 1, log 2, ...
                if expr.name in ("log0", "log1", "log2", "log3", "log4"):
                    topic_count = int(expr.name[3])
                    return bb.append_instruction("log", topic_count, *reversed(args))
                return bb.append_instruction(expr.name, *reversed(args))
        raise NotImplementedError(f"Expr {type(expr)} not implemented: {expr}")


def compile_to_venom(ast_nodes: YulObject) -> IRContext:
    builder = YulToVenom()
    return builder.compile(ast_nodes)


if __name__ == "__main__":
    _parse_args(sys.argv[1:])
