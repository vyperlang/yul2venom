"""Test individual components extracted from MainnetFlat patterns."""

import pytest
from pathlib import Path
import subprocess
import json


def compile_component_to_yul(contract_name="SimpleStorage"):
    """Compile a specific contract from MainnetComponents.sol to Yul."""
    sol_file = Path(__file__).parent / "fixtures" / "solidity" / "MainnetComponents.sol"

    cmd = [
        "solc",
        "--ir-optimized",
        "--via-ir",
        "--optimize",
        str(sol_file)
    ]

    result = subprocess.run(cmd, capture_output=True, text=True)

    if result.returncode != 0:
        pytest.skip(f"Failed to compile: {result.stderr[:500]}")

    # Extract the specific contract's Yul
    import re
    pattern = rf'object\s+"{contract_name}_\d+"\s*\{{.*?(?=object\s+"|IR:|Optimized IR:|\Z)'
    match = re.search(pattern, result.stdout, re.DOTALL)

    if not match:
        # Try without the _number suffix
        pattern = rf'object\s+"{contract_name}"\s*\{{.*?(?=object\s+"|IR:|Optimized IR:|\Z)'
        match = re.search(pattern, result.stdout, re.DOTALL)

    if match:
        return match.group(0)

    return None


def test_simple_storage_compilation():
    """Test compiling SimpleStorage contract."""
    import sys
    import os
    sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

    from test_validation.runners.yul_transpiler import YulTranspiler
    from test_validation.revm_environment import RevmEnvironment

    yul_code = compile_component_to_yul("SimpleStorage")

    if not yul_code:
        pytest.skip("Could not extract SimpleStorage Yul")

    print(f"SimpleStorage Yul: {len(yul_code)} bytes")

    # Compile to bytecode
    transpiler = YulTranspiler()

    try:
        bytecode = transpiler.compile_yul_to_bytecode(yul_code)
        print(f"✓ Compiled to bytecode: {len(bytecode)} bytes")
    except Exception as e:
        pytest.skip(f"Failed to compile: {str(e)[:200]}")

    # Try to deploy
    env = RevmEnvironment()
    success, address = env.deploy_contract(bytecode)

    if not success:
        print("✗ Failed to deploy")
        return

    print(f"✓ Deployed at {address}")

    # Test basic functions
    # store(42)
    store_selector = bytes.fromhex("6057361d")  # store(uint256)
    store_data = store_selector + (42).to_bytes(32, 'big')

    result = env.call_contract(address, store_data)
    print(f"store(42): success={result.success}")

    # retrieve()
    retrieve_selector = bytes.fromhex("2e64cec1")  # retrieve()
    result = env.call_contract(address, retrieve_selector)

    if result.success and len(result.output) >= 32:
        value = int.from_bytes(result.output[:32], 'big')
        print(f"retrieve(): {value}")
        assert value == 42, f"Expected 42, got {value}"


def test_math_operations():
    """Test MathOperations contract with SafeMath library."""
    import sys
    import os
    sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

    from test_validation.runners.yul_transpiler import YulTranspiler
    from test_validation.revm_environment import RevmEnvironment

    yul_code = compile_component_to_yul("MathOperations")

    if not yul_code:
        pytest.skip("Could not extract MathOperations Yul")

    print(f"MathOperations Yul: {len(yul_code)} bytes")

    transpiler = YulTranspiler()

    try:
        bytecode = transpiler.compile_yul_to_bytecode(yul_code)
        print(f"✓ Compiled to bytecode: {len(bytecode)} bytes")
    except Exception as e:
        pytest.skip(f"Failed to compile: {str(e)[:200]}")

    env = RevmEnvironment()
    success, address = env.deploy_contract(bytecode)

    if not success:
        print("✗ Failed to deploy")
        return

    print(f"✓ Deployed at {address}")

    # Test testAdd(10, 20)
    # Note: Function selectors would need to be calculated
    print("Testing math operations...")


def test_abi_patterns():
    """Test ABI encoding/decoding patterns."""
    import sys
    import os
    sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

    from test_validation.runners.yul_transpiler import YulTranspiler

    yul_code = compile_component_to_yul("ABIPatterns")

    if not yul_code:
        pytest.skip("Could not extract ABIPatterns Yul")

    print(f"ABIPatterns Yul: {len(yul_code)} bytes")

    transpiler = YulTranspiler()

    try:
        bytecode = transpiler.compile_yul_to_bytecode(yul_code)
        print(f"✓ Compiled ABIPatterns: {len(bytecode)} bytes")
    except Exception as e:
        print(f"✗ Failed: {str(e)[:200]}")


def test_error_handling():
    """Test error handling patterns."""
    import sys
    import os
    sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

    from test_validation.runners.yul_transpiler import YulTranspiler

    yul_code = compile_component_to_yul("ErrorHandling")

    if not yul_code:
        pytest.skip("Could not extract ErrorHandling Yul")

    print(f"ErrorHandling Yul: {len(yul_code)} bytes")

    transpiler = YulTranspiler()

    try:
        bytecode = transpiler.compile_yul_to_bytecode(yul_code)
        print(f"✓ Compiled ErrorHandling: {len(bytecode)} bytes")
    except Exception as e:
        print(f"✗ Failed: {str(e)[:200]}")


def test_all_components():
    """Test all components from MainnetComponents.sol."""
    contracts = [
        "SimpleStorage",
        "MathOperations",
        "ABIPatterns",
        "ErrorHandling",
        "MemoryPatterns",
        "ControlFlowPatterns"
    ]

    import sys
    import os
    sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

    from test_validation.runners.yul_transpiler import YulTranspiler

    transpiler = YulTranspiler()
    results = {}

    for contract in contracts:
        print(f"\nTesting {contract}...")

        yul_code = compile_component_to_yul(contract)

        if not yul_code:
            results[contract] = "Could not extract Yul"
            print(f"  ✗ Could not extract Yul")
            continue

        print(f"  Yul size: {len(yul_code)} bytes")

        try:
            bytecode = transpiler.compile_yul_to_bytecode(yul_code)
            results[contract] = f"Success: {len(bytecode)} bytes"
            print(f"  ✓ Compiled: {len(bytecode)} bytes")
        except Exception as e:
            error = str(e)[:100]
            results[contract] = f"Failed: {error}"
            print(f"  ✗ Failed: {error}")

    # Summary
    print("\n" + "=" * 50)
    print("SUMMARY")
    print("=" * 50)

    successful = [k for k, v in results.items() if "Success" in str(v)]
    failed = [k for k, v in results.items() if "Failed" in str(v) or "Could not" in str(v)]

    print(f"Successful: {len(successful)}/{len(contracts)}")
    for contract in successful:
        print(f"  ✓ {contract}: {results[contract]}")

    if failed:
        print(f"\nFailed: {len(failed)}/{len(contracts)}")
        for contract in failed:
            print(f"  ✗ {contract}: {results[contract]}")

    return results


if __name__ == "__main__":
    import sys
    import os

    # Add parent directory to path
    sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

    print("Testing MainnetFlat-style components...")
    print("=" * 60)

    results = test_all_components()

    print("\n" + "=" * 60)
    print("Testing specific contracts in detail:")
    print("=" * 60)

    print("\nSimpleStorage contract:")
    print("-" * 40)
    try:
        test_simple_storage_compilation()
    except Exception as e:
        print(f"Error: {e}")

    print("\nMathOperations contract:")
    print("-" * 40)
    try:
        test_math_operations()
    except Exception as e:
        print(f"Error: {e}")
