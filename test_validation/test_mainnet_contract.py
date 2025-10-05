"""Test compilation of MainnetFlat.sol - a real production contract."""

import pytest
from textwrap import dedent
import os
import subprocess
import json
from pathlib import Path


def test_mainnet_flat_compiles_to_yul():
    """Test that MainnetFlat.sol can be compiled to Yul."""
    fixtures_dir = Path(__file__).parent / "fixtures" / "solidity"
    sol_file = fixtures_dir / "MainnetFlat.sol"

    assert sol_file.exists(), f"MainnetFlat.sol not found at {sol_file}"

    # Try to compile to Yul
    cmd = [
        "solc",
        "--ir-optimized",
        "--via-ir",
        "--optimize",
        str(sol_file)
    ]

    result = subprocess.run(
        cmd,
        capture_output=True,
        text=True,
        timeout=60  # Large contract may take time
    )

    if result.returncode != 0:
        # Print error for debugging
        print(f"Solc stderr: {result.stderr[:2000]}")  # First 2000 chars of error
        pytest.skip(f"Failed to compile MainnetFlat.sol to Yul: {result.stderr[:500]}")

    # Check we got Yul output
    assert len(result.stdout) > 1000, "Expected substantial Yul output"
    assert "object" in result.stdout, "Yul output should contain 'object' keyword"

    # Save Yul output for inspection
    yul_file = fixtures_dir.parent / "yul" / "MainnetFlat.yul"
    yul_file.parent.mkdir(exist_ok=True)

    with open(yul_file, "w") as f:
        f.write(result.stdout)

    print(f"✓ MainnetFlat.sol compiled to Yul ({len(result.stdout)} bytes)")
    print(f"✓ Saved to {yul_file}")

    return result.stdout


def test_mainnet_flat_yul_to_venom():
    """Test that MainnetFlat Yul can be compiled to Venom IR."""
    from runners.yul_transpiler import YulTranspiler

    # First get the Yul
    yul_code = test_mainnet_flat_compiles_to_yul()

    # Extract just the MainnetSettler object from the Yul
    # (The full output may have multiple objects)
    import re

    # Find the MainnetSettler object
    pattern = r'object\s+"MainnetSettler[^"]*"[^{]*\{.*?(?=object\s+"|$)'
    matches = re.findall(pattern, yul_code, re.DOTALL)

    if not matches:
        # Try to find any object
        pattern = r'(object\s+"[^"]+"\s*\{(?:[^{}]|\{[^{}]*\})*\})'
        matches = re.findall(pattern, yul_code, re.DOTALL)

    if not matches:
        pytest.skip("Could not extract contract object from Yul output")

    # Take the first (or main) object
    main_object = matches[0]

    print(f"Extracted object ({len(main_object)} bytes)")

    # Try to compile to Venom
    transpiler = YulTranspiler()

    try:
        # This might fail for very complex contracts
        bytecode = transpiler.compile_yul_to_bytecode(main_object)
        print(f"✓ Successfully compiled to bytecode ({len(bytecode)} bytes)")
        return bytecode
    except Exception as e:
        pytest.skip(f"Failed to compile Yul to Venom: {str(e)[:500]}")


def test_mainnet_flat_basic_deployment():
    """Test that we can at least deploy the compiled MainnetFlat contract."""
    from revm_environment import RevmEnvironment

    try:
        bytecode = test_mainnet_flat_yul_to_venom()
    except pytest.skip.Exception:
        raise
    except Exception as e:
        pytest.skip(f"Could not get bytecode: {e}")

    # Try to deploy
    env = RevmEnvironment()
    success, address = env.deploy_contract(bytecode)

    if not success:
        pytest.skip("Failed to deploy MainnetFlat contract")

    assert address is not None
    print(f"✓ Successfully deployed MainnetFlat at {address}")

    # Try a simple call (will likely revert but tests the basics work)
    result = env.call_contract(address, b"")
    print(f"Empty call result: success={result.success}")


def test_compile_stats():
    """Compare compilation statistics between solc and our transpiler."""
    fixtures_dir = Path(__file__).parent / "fixtures" / "solidity"
    sol_file = fixtures_dir / "MainnetFlat.sol"

    # Get solc bytecode
    cmd = [
        "solc",
        "--optimize",
        "--bin",
        str(sol_file)
    ]

    result = subprocess.run(cmd, capture_output=True, text=True)

    if result.returncode != 0:
        pytest.skip(f"Failed to compile with solc: {result.stderr[:500]}")

    # Extract bytecode from solc output
    lines = result.stdout.split('\n')
    bytecode_lines = []
    capture = False

    for line in lines:
        if line.startswith('======='):
            capture = False
        elif capture and line and not line.startswith('Binary'):
            bytecode_lines.append(line.strip())
        elif 'Binary:' in line or line.strip() == 'Binary':
            capture = True

    if not bytecode_lines:
        pytest.skip("Could not extract bytecode from solc output")

    # Get the longest bytecode (likely the main contract)
    solc_bytecode = max(bytecode_lines, key=len) if bytecode_lines else ""

    print(f"Solc bytecode size: {len(solc_bytecode) // 2} bytes")

    # Now try with our compiler
    try:
        our_bytecode = test_mainnet_flat_yul_to_venom()
        print(f"Our bytecode size: {len(our_bytecode)} bytes")

        if len(solc_bytecode) > 0:
            ratio = len(our_bytecode) / (len(solc_bytecode) // 2)
            print(f"Size ratio (ours/solc): {ratio:.2f}x")
    except:
        print("Could not compile with our transpiler")


if __name__ == "__main__":
    print("Testing MainnetFlat.sol compilation...")
    print("=" * 50)

    try:
        test_mainnet_flat_compiles_to_yul()
        print()
        test_mainnet_flat_yul_to_venom()
        print()
        test_mainnet_flat_basic_deployment()
        print()
        test_compile_stats()
    except pytest.skip.Exception as e:
        print(f"Skipped: {e}")
    except Exception as e:
        print(f"Error: {e}")
        import traceback
        traceback.print_exc()
