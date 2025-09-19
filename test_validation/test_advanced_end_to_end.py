"""Advanced end-to-end tests for the Yul→Venom pipeline."""

from textwrap import dedent

import pytest

from test_validation.test_cases import get_test_cases_for_contract
from test_validation.validators.execution_validator import ValidationResult


def test_advanced_features_contract(
    solc_compiler,
    yul_transpiler,
    execution_validator,
    fixtures_dir,
):
    """Ensure complex storage and control-flow heavy contracts behave identically."""
    sol_file = fixtures_dir / "solidity" / "AdvancedFeatures.sol"
    if not sol_file.exists():
        pytest.skip(f"missing AdvancedFeatures fixture: {sol_file}")

    # Reference compilation path (Solidity → bytecode)
    deploy_bytecode, _ = solc_compiler.compile_to_bytecode(sol_file)

    # Transpile via Yul → Venom → bytecode
    yul_code = solc_compiler.compile_to_yul(sol_file)
    transpiled_bytecode = yul_transpiler.compile_yul_to_bytecode(yul_code)

    # Load execution scenarios covering storage mutations and heavy control flow
    test_cases = get_test_cases_for_contract("AdvancedFeatures")
    assert test_cases, "Expected execution test cases for AdvancedFeatures"

    reports = execution_validator.validate_execution(
        deploy_bytecode,
        transpiled_bytecode,
        test_cases,
    )

    assert reports, "Validator returned no reports"

    failures = [report for report in reports if report.status != ValidationResult.PASS]
    if failures:
        details = "\n".join(
            f"{report.test_name}: {report.status.value} - {report.message}"
            for report in failures
        )
        pytest.fail(
            dedent(
                f"""
                AdvancedFeatures contract mismatched between reference and transpiled bytecode.
                {details}
                """
            ).strip()
        )

    # Ensure deployment was exercised and passed for clarity when triaging failures
    assert reports[0].test_name == "deployment"
    assert reports[0].status == ValidationResult.PASS
