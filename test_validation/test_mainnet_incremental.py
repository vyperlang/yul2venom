"""Incremental testing of MainnetFlat.sol - test individual components."""

import pytest
from textwrap import dedent
import subprocess
import re
from pathlib import Path


def extract_yul_objects(yul_code):
    """Extract individual Yul objects from the full output."""
    objects = {}

    # Pattern to match Yul objects
    pattern = r'object\s+"([^"]+)"\s*\{((?:[^{}]|\{(?:[^{}]|\{[^{}]*\})*\})*)\}'

    matches = re.finditer(pattern, yul_code, re.DOTALL)

    for match in matches:
        name = match.group(1)
        content = match.group(0)  # Full object including header
        objects[name] = content

    return objects


def get_simple_libraries():
    """Extract simple library objects that might be compilable."""
    yul_file = Path(__file__).parent / "fixtures" / "yul" / "MainnetFlat.yul"

    if not yul_file.exists():
        # Generate it first
        sol_file = Path(__file__).parent / "fixtures" / "solidity" / "MainnetFlat.sol"
        cmd = ["solc", "--ir-optimized", "--via-ir", "--optimize", str(sol_file)]
        result = subprocess.run(cmd, capture_output=True, text=True)

        if result.returncode != 0:
            pytest.skip(f"Failed to compile: {result.stderr[:500]}")

        yul_file.parent.mkdir(exist_ok=True)
        yul_file.write_text(result.stdout)

    yul_code = yul_file.read_text()
    objects = extract_yul_objects(yul_code)

    # Filter for simpler objects (libraries tend to be simpler)
    simple_objects = {}
    for name, content in objects.items():
        # Skip deployed versions and very large objects
        if "_deployed" not in name and len(content) < 50000:
            simple_objects[name] = content

    return simple_objects


def test_compile_simple_libraries():
    """Test compiling individual library objects."""
    import sys
    import os
    sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

    from test_validation.runners.yul_transpiler import YulTranspiler

    libraries = get_simple_libraries()

    if not libraries:
        pytest.skip("No simple libraries found to test")

    print(f"Found {len(libraries)} library objects to test:")
    for name in libraries:
        print(f"  - {name} ({len(libraries[name])} bytes)")

    transpiler = YulTranspiler()
    results = {}

    for name, yul_obj in libraries.items():
        print(f"\nTesting {name}...")

        try:
            # Try to compile this object
            bytecode = transpiler.compile_yul_to_bytecode(yul_obj)
            results[name] = {
                'status': 'success',
                'bytecode_size': len(bytecode),
                'yul_size': len(yul_obj)
            }
            print(f"  ✓ Success: {len(bytecode)} bytes bytecode")

        except Exception as e:
            error_msg = str(e)[:200]
            results[name] = {
                'status': 'failed',
                'error': error_msg,
                'yul_size': len(yul_obj)
            }
            print(f"  ✗ Failed: {error_msg}")

    # Summary
    print("\n" + "=" * 50)
    print("SUMMARY")
    print("=" * 50)

    successful = [k for k, v in results.items() if v['status'] == 'success']
    failed = [k for k, v in results.items() if v['status'] == 'failed']

    print(f"Successful: {len(successful)}/{len(results)}")
    if successful:
        print("  Compiled successfully:")
        for name in successful:
            print(f"    - {name}: {results[name]['bytecode_size']} bytes")

    if failed:
        print(f"\nFailed: {len(failed)}/{len(results)}")
        for name in failed[:5]:  # Show first 5 failures
            print(f"    - {name}: {results[name]['error'][:100]}")

    return results


def test_extract_specific_functions():
    """Extract and test specific function patterns from MainnetFlat."""

    yul_file = Path(__file__).parent / "fixtures" / "yul" / "MainnetFlat.yul"

    if not yul_file.exists():
        pytest.skip("Yul file not found")

    yul_code = yul_file.read_text()

    # Look for simple utility functions
    function_pattern = r'function\s+(\w+)\s*\([^)]*\)[^{]*\{([^}]+)\}'

    matches = re.finditer(function_pattern, yul_code)

    simple_functions = []
    for match in matches:
        func_name = match.group(1)
        func_body = match.group(2)

        # Skip complex functions
        if len(func_body) < 200 and func_body.count('{') < 2:
            simple_functions.append({
                'name': func_name,
                'code': match.group(0)
            })

    print(f"Found {len(simple_functions)} simple functions")

    # Create minimal Yul objects for these functions
    test_cases = []
    for func in simple_functions[:10]:  # Test first 10
        yul_obj = dedent(f"""
            object "Test_{func['name']}" {{
                code {{
                    {func['code']}

                    // Test call
                    stop()
                }}
            }}
        """)
        test_cases.append((func['name'], yul_obj))

    # Test compilation
    from test_validation.runners.yul_transpiler import YulTranspiler
    transpiler = YulTranspiler()

    results = {}
    for name, yul_obj in test_cases:
        try:
            bytecode = transpiler.compile_yul_to_bytecode(yul_obj)
            results[name] = 'success'
            print(f"✓ {name}")
        except Exception as e:
            results[name] = str(e)[:50]
            print(f"✗ {name}: {results[name]}")

    return results


def test_mainnet_patterns():
    """Test specific patterns found in MainnetFlat that might be problematic."""

    test_patterns = [
        # Test ABI decode patterns
        ("abi_decode_pattern", dedent("""
            object "TestAbiDecode" {
                code {
                    function abi_decode_t_uint256(offset, end) -> value {
                        value := calldataload(offset)
                        if iszero(slt(add(offset, 0x1f), end)) { revert(0, 0) }
                    }

                    function abi_decode_tuple_t_uint256(headStart, dataEnd) -> value0 {
                        if slt(sub(dataEnd, headStart), 32) { revert(0, 0) }
                        value0 := abi_decode_t_uint256(headStart, dataEnd)
                    }

                    let x := abi_decode_tuple_t_uint256(4, calldatasize())
                    mstore(0, x)
                    return(0, 32)
                }
            }
        """)),

        # Test memory management patterns
        ("memory_pattern", dedent("""
            object "TestMemory" {
                code {
                    function allocate_unbounded() -> memPtr {
                        memPtr := mload(64)
                    }

                    function allocate_memory(size) -> memPtr {
                        memPtr := allocate_unbounded()
                        let newFreePtr := add(memPtr, round_up_to_mul_of_32(size))
                        if or(gt(newFreePtr, 0xffffffffffffffff), lt(newFreePtr, memPtr)) {
                            revert(0, 0)
                        }
                        mstore(64, newFreePtr)
                    }

                    function round_up_to_mul_of_32(value) -> result {
                        result := and(add(value, 31), not(31))
                    }

                    let mem := allocate_memory(64)
                    mstore(mem, 42)
                    return(mem, 32)
                }
            }
        """)),

        # Test error handling patterns
        ("error_pattern", dedent("""
            object "TestErrors" {
                code {
                    function revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() {
                        revert(0, 0)
                    }

                    function panic_error_0x41() {
                        mstore(0, 0x4e487b7100000000000000000000000000000000000000000000000000000000)
                        mstore(4, 0x41)
                        revert(0, 0x24)
                    }

                    // Test
                    if iszero(lt(calldatasize(), 4)) {
                        panic_error_0x41()
                    }
                    stop()
                }
            }
        """))
    ]

    from test_validation.runners.yul_transpiler import YulTranspiler
    transpiler = YulTranspiler()

    for name, yul_code in test_patterns:
        print(f"\nTesting pattern: {name}")
        try:
            bytecode = transpiler.compile_yul_to_bytecode(yul_code)
            print(f"  ✓ Success: {len(bytecode)} bytes")
        except Exception as e:
            print(f"  ✗ Failed: {str(e)[:100]}")


if __name__ == "__main__":
    import sys
    import os

    # Add parent directory to path
    sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

    print("Testing MainnetFlat.sol components incrementally...")
    print("=" * 60)

    print("\n1. Testing simple libraries:")
    print("-" * 40)
    test_compile_simple_libraries()

    print("\n2. Testing specific functions:")
    print("-" * 40)
    test_extract_specific_functions()

    print("\n3. Testing common patterns:")
    print("-" * 40)
    test_mainnet_patterns()
