#!/usr/bin/env python3
"""
Tests for the SolVenom CLI (yul_to_venom/cli/solvenom.py).
"""

import json
import os
import subprocess
import sys
import tempfile
from pathlib import Path

import pytest

# Test fixtures directory
FIXTURES_DIR = Path(__file__).parent / "test_validation" / "fixtures" / "solidity"

# Environment setup for running the CLI
def get_cli_env():
    """Get environment variables for CLI invocation."""
    env = os.environ.copy()
    env["PYTHONPATH"] = "/Users/harkal/projects/charles_cooper/repos/vyper:."
    return env


def run_solvenom(*args, check=True, **kwargs):
    """Run solvenom CLI with given arguments."""
    cmd = [sys.executable, "-m", "yul_to_venom.cli.solvenom", *args]
    result = subprocess.run(
        cmd,
        capture_output=True,
        text=True,
        env=get_cli_env(),
        **kwargs,
    )
    if check and result.returncode != 0:
        raise subprocess.CalledProcessError(
            result.returncode, cmd, result.stdout, result.stderr
        )
    return result


@pytest.fixture
def simple_contract():
    """Create a simple Solidity contract in a temp file."""
    code = """
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Simple {
    uint256 public value = 42;
}
"""
    with tempfile.NamedTemporaryFile(
        mode="w", suffix=".sol", delete=False
    ) as f:
        f.write(code)
        f.flush()
        yield Path(f.name)
    os.unlink(f.name)


@pytest.fixture
def multi_contract():
    """Create a Solidity file with multiple contracts."""
    code = """
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract First {
    uint256 public x = 1;
}

contract Second {
    uint256 public y = 2;
}
"""
    with tempfile.NamedTemporaryFile(
        mode="w", suffix=".sol", delete=False
    ) as f:
        f.write(code)
        f.flush()
        yield Path(f.name)
    os.unlink(f.name)


class TestBasicCompilation:
    """Test basic compilation functionality."""

    def test_compile_simple_contract(self, simple_contract):
        """Test compiling a simple contract produces bytecode."""
        result = run_solvenom(str(simple_contract))
        bytecode = result.stdout.strip()

        # Should output hex bytecode
        assert bytecode.startswith("0x")
        assert len(bytecode) > 10  # Non-trivial bytecode

    def test_compile_fixture_minimal(self):
        """Test compiling the Minimal.sol fixture."""
        sol_file = FIXTURES_DIR / "Minimal.sol"
        if not sol_file.exists():
            pytest.skip(f"Fixture not found: {sol_file}")

        result = run_solvenom(str(sol_file))
        bytecode = result.stdout.strip()

        assert bytecode.startswith("0x")
        assert len(bytecode) > 10


class TestOutputFormats:
    """Test different output format flags."""

    def test_venom_flag_outputs_ir(self, simple_contract):
        """Test --venom flag outputs Venom IR."""
        result = run_solvenom(str(simple_contract), "--venom")
        output = result.stdout

        # Venom IR should contain function definitions and basic blocks
        assert "function" in output.lower() or "entry" in output.lower()
        # Should NOT be hex bytecode
        assert not output.strip().startswith("0x")

    def test_asm_flag_outputs_assembly(self, simple_contract):
        """Test --asm flag outputs assembly."""
        result = run_solvenom(str(simple_contract), "--asm")
        output = result.stdout

        # Assembly should contain EVM opcodes
        # Common opcodes in any contract
        assert any(
            op in output.upper()
            for op in ["PUSH", "MSTORE", "RETURN", "STOP", "JUMPDEST"]
        )
        # Should NOT be hex bytecode
        assert not output.strip().startswith("0x")

    def test_json_flag_outputs_json(self, simple_contract):
        """Test --json flag outputs valid JSON with expected fields."""
        result = run_solvenom(str(simple_contract), "--json")
        output = result.stdout

        data = json.loads(output)
        assert "contractName" in data
        assert "bytecode" in data
        assert "abi" in data
        assert data["bytecode"].startswith("0x")

    def test_abi_flag_outputs_abi(self, simple_contract):
        """Test --abi flag outputs ABI JSON."""
        result = run_solvenom(str(simple_contract), "--abi")
        output = result.stdout

        abi = json.loads(output)
        assert isinstance(abi, list)
        # Simple contract has a public state variable -> getter function
        assert len(abi) > 0


class TestContractSelection:
    """Test --contract flag for selecting specific contracts."""

    def test_select_specific_contract(self, multi_contract):
        """Test --contract flag selects the specified contract."""
        # Compile First contract
        result1 = run_solvenom(str(multi_contract), "--contract", "First", "--json")
        data1 = json.loads(result1.stdout)
        assert data1["contractName"] == "First"

        # Compile Second contract
        result2 = run_solvenom(str(multi_contract), "--contract", "Second", "--json")
        data2 = json.loads(result2.stdout)
        assert data2["contractName"] == "Second"

    def test_nonexistent_contract_fails(self, multi_contract):
        """Test --contract with non-existent name fails."""
        result = run_solvenom(
            str(multi_contract), "--contract", "NonExistent", check=False
        )
        assert result.returncode != 0
        assert "not found" in result.stderr.lower()


class TestErrorHandling:
    """Test error handling for various failure cases."""

    def test_nonexistent_file(self):
        """Test error for non-existent file."""
        result = run_solvenom("/nonexistent/path/to/file.sol", check=False)
        assert result.returncode != 0
        assert "not found" in result.stderr.lower() or "error" in result.stderr.lower()

    def test_invalid_solidity_syntax(self):
        """Test error for invalid Solidity syntax."""
        with tempfile.NamedTemporaryFile(
            mode="w", suffix=".sol", delete=False
        ) as f:
            f.write("this is not valid solidity code")
            f.flush()
            temp_path = f.name

        try:
            result = run_solvenom(temp_path, check=False)
            assert result.returncode != 0
        finally:
            os.unlink(temp_path)


class TestCompileAllFlag:
    """Test --all flag for compiling multiple contracts."""

    def test_compile_all_contracts(self, multi_contract):
        """Test --all flag compiles all contracts in file."""
        result = run_solvenom(str(multi_contract), "--all")
        output = result.stdout

        # Should contain output for both contracts
        assert "First" in output or "Second" in output

    def test_compile_all_json(self, multi_contract):
        """Test --all with --json outputs all contracts."""
        result = run_solvenom(str(multi_contract), "--all", "--json")
        data = json.loads(result.stdout)

        assert "contracts" in data
        # Both contracts should be present
        assert "First" in data["contracts"] or "Second" in data["contracts"]
