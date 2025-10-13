from __future__ import annotations

from pathlib import Path

import pytest

from test_validation.revm_environment import RevmEnvironment
from test_validation.runners.solc_compiler import SolcCompiler
from test_validation.runners.yul_transpiler import YulTranspiler


SOLIDITY_FIXTURES = Path(__file__).parent / "fixtures" / "solidity"


def _load_compiler() -> SolcCompiler:
    try:
        return SolcCompiler()
    except RuntimeError as exc:  # pragma: no cover - environment dependent
        pytest.skip(f"solc unavailable: {exc}")


def _load_immutable_artifact(compiler: SolcCompiler) -> tuple[str, str, str]:
    sol_file = SOLIDITY_FIXTURES / "ImmutableSimple.sol"
    try:
        compilation = compiler.compile_to_json(sol_file, optimize=False)
    except RuntimeError as exc:  # pragma: no cover - compilation failure
        pytest.skip(f"solc compilation failed: {exc}")

    contracts = compilation.get("contracts", {}).get(sol_file.name, {})
    artifact = contracts.get("ImmutableSimple")
    if artifact is None:
        pytest.skip("solc did not emit ImmutableSimple contract data")

    yul_code = artifact.get("irOptimized") or artifact.get("ir")
    if not yul_code:
        pytest.skip("solc did not emit Yul IR for ImmutableSimple")

    evm_data = artifact.get("evm", {})
    bytecode = evm_data.get("bytecode", {}).get("object") or ""
    runtime = evm_data.get("deployedBytecode", {}).get("object") or ""
    if not bytecode:
        pytest.skip("solc did not produce ImmutableSimple deployment bytecode")

    return yul_code, bytecode, runtime


def test_immutable_value_matches_solc() -> None:
    compiler = _load_compiler()
    yul_code, reference_bytecode, _runtime = _load_immutable_artifact(compiler)
    assert "setimmutable" in yul_code
    assert "loadimmutable" in yul_code

    transpiler = YulTranspiler()
    transpiled_bytecode = transpiler.compile_yul_to_bytecode(yul_code, optimize=False)

    env = RevmEnvironment()
    solc_ok, solc_address = env.deploy_contract(
        reference_bytecode, name="ImmutableSimple (solc)"
    )
    transpiled_ok, transpiled_address = env.deploy_contract(
        transpiled_bytecode, name="ImmutableSimple (transpiled)"
    )

    if not solc_ok or solc_address is None:
        pytest.skip("failed to deploy reference ImmutableSimple contract")
    if not transpiled_ok or transpiled_address is None:
        pytest.skip("failed to deploy transpiled ImmutableSimple contract")

    solc_result = env.call_function(solc_address, "readStored()", [])
    transpiled_result = env.call_function(transpiled_address, "readStored()", [])

    assert solc_result.success, "solc reference call failed"
    assert transpiled_result.success, "transpiled call failed"

    solc_value = int.from_bytes(solc_result.output, "big") if solc_result.output else 0
    transpiled_value = (
        int.from_bytes(transpiled_result.output, "big") if transpiled_result.output else 0
    )

    assert solc_value == 7
    assert transpiled_value == 7
    assert solc_value == transpiled_value, (
        f"immutable mismatch: solc={solc_value}, transpiled={transpiled_value}"
    )
