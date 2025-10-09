from __future__ import annotations

from pathlib import Path
from typing import Tuple

import pytest

from test_validation.runners.solc_compiler import SolcCompiler
from test_validation.runners.yul_transpiler import YulTranspiler
from test_validation.revm_environment import RevmEnvironment


SOLIDITY_FIXTURES = Path(__file__).parent / "fixtures" / "solidity"


def _decode_words(data: bytes, count: int) -> Tuple[int, ...]:
    if len(data) < count * 32:
        raise AssertionError(f"expected {count} words, received {len(data)} bytes")
    return tuple(int.from_bytes(data[i * 32 : (i + 1) * 32], "big") for i in range(count))


def _load_compiler() -> SolcCompiler:
    try:
        return SolcCompiler()
    except RuntimeError as exc:  # pragma: no cover - environment dependent
        pytest.skip(f"solc unavailable: {exc}")


def _compile_math512_yul(compiler: SolcCompiler) -> str:
    sol_file = SOLIDITY_FIXTURES / "Math512WithDeps.sol"
    try:
        compilation = compiler.compile_to_json(sol_file, optimize=False)
    except RuntimeError as exc:  # pragma: no cover - compilation failure
        pytest.skip(f"solc compilation failed: {exc}")

    contracts = compilation.get("contracts", {}).get(sol_file.name, {})
    harness = contracts.get("Math512Harness")
    if harness is None:
        pytest.skip("solc did not emit Math512Harness contract data")

    yul_code = harness.get("irOptimized") or harness.get("ir")
    if not yul_code:
        pytest.skip("solc did not emit Yul IR for Math512Harness")

    return yul_code


def _compile_math512_bytecode(compiler: SolcCompiler) -> Tuple[str, str]:
    sol_file = SOLIDITY_FIXTURES / "Math512WithDeps.sol"
    try:
        compilation = compiler.compile_to_json(sol_file, optimize=False)
    except RuntimeError as exc:  # pragma: no cover - compilation failure
        pytest.skip(f"solc bytecode compilation failed: {exc}")

    contracts = compilation.get("contracts", {}).get(sol_file.name, {})
    harness = contracts.get("Math512Harness")
    if harness is None:
        pytest.skip("solc did not emit Math512Harness contract data")

    evm_data = harness.get("evm", {})
    bytecode = evm_data.get("bytecode", {}).get("object") or ""
    runtime = evm_data.get("deployedBytecode", {}).get("object") or ""
    if not bytecode:
        pytest.skip("solc did not produce Math512Harness deployment bytecode")

    return bytecode, runtime


def test_math512_harness_behaves_with_solc() -> None:
    compiler = _load_compiler()
    creation_bytecode, _runtime = _compile_math512_bytecode(compiler)
    if not creation_bytecode:
        pytest.skip("solc did not produce deployment bytecode")

    env = RevmEnvironment()
    success, address = env.deploy_contract(creation_bytecode, name="Math512Harness")
    if not success or address is None:
        pytest.skip("failed to deploy Math512Harness via solc bytecode")

    result = env.call_function(address, "addUint256(uint256,uint256)", [1, 2])
    assert result.success
    hi, lo = _decode_words(result.output, 2)
    assert hi == 0
    assert lo == 3

    full_hi = 1
    full_lo = (1 << 256) - 1
    result = env.call_function(
        address,
        "addUint512Scalar(uint256,uint256,uint256)",
        [full_hi, full_lo, 1],
    )
    assert result.success
    hi, lo = _decode_words(result.output, 2)
    assert hi == full_hi + 1
    assert lo == 0

    result = env.call_function(
        address,
        "addUint512(uint256,uint256,uint256,uint256)",
        [0, 7, 0, 9],
    )
    assert result.success
    hi, lo = _decode_words(result.output, 2)
    assert hi == 0
    assert lo == 16

    base_a = 1 << 200
    base_b = 1 << 60
    result = env.call_function(address, "mulUint256(uint256,uint256)", [base_a, base_b])
    assert result.success
    hi, lo = _decode_words(result.output, 2)
    assert hi == 16
    assert lo == 0

    result = env.call_function(
        address,
        "gtUint512(uint256,uint256,uint256,uint256)",
        [1, 0, 0, (1 << 256) - 1],
    )
    assert result.success
    (is_gt,) = _decode_words(result.output, 1)
    assert bool(is_gt) is True

    result = env.call_function(
        address,
        "compareToScalar(uint256,uint256,uint256)",
        [0, 123, 123],
    )
    assert result.success
    greater, equal = _decode_words(result.output, 2)
    assert not bool(greater)
    assert bool(equal)

    modulus = 97
    result = env.call_function(
        address,
        "modUint512(uint256,uint256,uint256)",
        [2, 5, modulus],
    )
    assert result.success
    (mod_value,) = _decode_words(result.output, 1)
    expected_mod = (2 * (1 << 256) + 5) % modulus
    assert mod_value == expected_mod

    result = env.call_function(
        address,
        "roundTripExternal(uint256,uint256)",
        [0x1234, 0x5678],
    )
    assert result.success
    hi, lo = _decode_words(result.output, 2)
    assert hi == 0x1234
    assert lo == 0x5678


def test_math512_transpiler_generates_outputs() -> None:
    compiler = _load_compiler()
    yul_code = _compile_math512_yul(compiler)

    transpiler = YulTranspiler()
    venom_ir = transpiler.compile_yul_to_venom_ir(yul_code)
    assert "Math512Harness" in venom_ir

    assembly = transpiler.compile_yul_to_assembly(yul_code, optimize=False)
    assert len(assembly) > 0

    bytecode = transpiler.compile_yul_to_bytecode(yul_code, optimize=False)
    assert bytecode.startswith("0x")
    assert len(bytecode) > 2
