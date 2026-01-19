"""Comprehensive tests for general ABI decode optimization."""

import pytest
from textwrap import dedent
import subprocess
import tempfile
import os
from pathlib import Path

# Repo root for path calculations
REPO_ROOT = Path(__file__).parent.parent


def get_vyper_path():
    """Get the path to the Vyper repository."""
    # Check env var first
    vyper_path = os.environ.get("VYPER_PATH")
    if vyper_path and os.path.isdir(vyper_path):
        return vyper_path
    # Fall back to sibling directory
    default_path = REPO_ROOT.parent / "vyper"
    if default_path.is_dir():
        return str(default_path)
    raise RuntimeError(
        "Vyper path not found. Set VYPER_PATH env var or clone vyper to ../vyper"
    )


def compile_yul_code(yul_code: str) -> str:
    """Helper to compile Yul code and return Venom IR."""
    with tempfile.NamedTemporaryFile(mode='w', suffix='.yul', delete=False) as f:
        f.write(yul_code)
        f.flush()
        yul_file = f.name

    try:
        # Get Venom IR output
        cmd = ["python", "yul_to_venom/cli/yul.py", "--venom", yul_file]
        env = os.environ.copy()
        env['PYTHONPATH'] = f'{get_vyper_path()}:.'

        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            env=env
        )

        if result.returncode != 0:
            raise RuntimeError(f"Yul compilation failed: {result.stderr}")

        return result.stdout
    finally:
        os.unlink(yul_file)


def test_abi_decode_optimization_patterns():
    """Test that various ABI decode patterns are optimized."""

    test_cases = [
        # (description, yul_code, should_be_inlined)
        ("single uint256", dedent("""
            object "Test" {
                code {
                    function abi_decode_tuple_t_uint256(headStart, dataEnd) -> value0 {
                        value0 := calldataload(headStart)
                    }
                    let x := abi_decode_tuple_t_uint256(4, calldatasize())
                    mstore(0, x)
                }
            }
        """), True),

        ("double uint256", dedent("""
            object "Test" {
                code {
                    function abi_decode_tuple_t_uint256t_uint256(headStart, dataEnd) -> value0, value1 {
                        value0 := calldataload(headStart)
                        value1 := calldataload(add(headStart, 32))
                    }
                    let x, y := abi_decode_tuple_t_uint256t_uint256(4, calldatasize())
                    mstore(0, x)
                    mstore(32, y)
                }
            }
        """), True),

        ("triple uint256", dedent("""
            object "Test" {
                code {
                    function abi_decode_tuple_t_uint256t_uint256t_uint256(headStart, dataEnd)
                        -> value0, value1, value2 {
                        value0 := calldataload(headStart)
                        value1 := calldataload(add(headStart, 32))
                        value2 := calldataload(add(headStart, 64))
                    }
                    let x, y, z := abi_decode_tuple_t_uint256t_uint256t_uint256(4, calldatasize())
                    mstore(0, x)
                }
            }
        """), True),

        ("quadruple uint256", dedent("""
            object "Test" {
                code {
                    function abi_decode_tuple_t_uint256t_uint256t_uint256t_uint256(headStart, dataEnd)
                        -> value0, value1, value2, value3 {
                        value0 := calldataload(headStart)
                        value1 := calldataload(add(headStart, 32))
                        value2 := calldataload(add(headStart, 64))
                        value3 := calldataload(add(headStart, 96))
                    }
                    let a, b, c, d := abi_decode_tuple_t_uint256t_uint256t_uint256t_uint256(4, calldatasize())
                    mstore(0, a)
                }
            }
        """), True),

        ("five uint256 (too many)", dedent("""
            object "Test" {
                code {
                    function abi_decode_tuple_t_uint256t_uint256t_uint256t_uint256t_uint256(headStart, dataEnd)
                        -> value0, value1, value2, value3, value4 {
                        value0 := calldataload(headStart)
                        value1 := calldataload(add(headStart, 32))
                        value2 := calldataload(add(headStart, 64))
                        value3 := calldataload(add(headStart, 96))
                        value4 := calldataload(add(headStart, 128))
                    }
                    let a, b, c, d, e := abi_decode_tuple_t_uint256t_uint256t_uint256t_uint256t_uint256(4, calldatasize())
                    mstore(0, a)
                }
            }
        """), False),  # Should NOT be inlined (>4 params)

        ("fromMemory single", dedent("""
            object "Test" {
                code {
                    function abi_decode_tuple_t_uint256_fromMemory(headStart, dataEnd) -> value0 {
                        value0 := mload(headStart)
                    }
                    let x := abi_decode_tuple_t_uint256_fromMemory(0, 32)
                    mstore(64, x)
                }
            }
        """), True),

        ("fromMemory double", dedent("""
            object "Test" {
                code {
                    function abi_decode_tuple_t_uint256t_uint256_fromMemory(headStart, dataEnd)
                        -> value0, value1 {
                        value0 := mload(headStart)
                        value1 := mload(add(headStart, 32))
                    }
                    let x, y := abi_decode_tuple_t_uint256t_uint256_fromMemory(0, 64)
                    mstore(64, x)
                    mstore(96, y)
                }
            }
        """), True),

        ("regular function (not ABI decode)", dedent("""
            object "Test" {
                code {
                    function my_custom_function(a, b) -> result {
                        result := add(a, b)
                    }
                    let sum := my_custom_function(10, 20)
                    mstore(0, sum)
                }
            }
        """), False),  # Regular function should use invoke
    ]

    for description, yul_code, should_be_inlined in test_cases:
        print(f"\nTesting: {description}")
        ir = compile_yul_code(yul_code)

        # Check if the function is being invoked or inlined
        has_invoke = "@abi_decode" in ir and "invoke" in ir

        if should_be_inlined:
            assert not has_invoke, f"{description}: Should be inlined but uses invoke"
            print(f"  ✓ Correctly inlined")
        else:
            assert has_invoke or "my_custom_function" in ir, f"{description}: Should use invoke but is inlined"
            print(f"  ✓ Correctly uses function call")


def test_type_specific_optimizations():
    """Test that type-specific optimizations are applied."""

    # Test address type masking
    yul_address = dedent("""
        object "Test" {
            code {
                function abi_decode_tuple_t_address(headStart, dataEnd) -> value0 {
                    value0 := and(calldataload(headStart), 0xffffffffffffffffffffffffffffffffffffffff)
                }
                let addr := abi_decode_tuple_t_address(4, calldatasize())
                mstore(0, addr)
            }
        }
    """)

    ir = compile_yul_code(yul_address)
    # Should contain an 'and' instruction for masking
    assert "and" in ir.lower(), "Address type should apply masking"
    print("✓ Address masking applied")

    # Test bool type conversion
    yul_bool = dedent("""
        object "Test" {
            code {
                function abi_decode_tuple_t_bool(headStart, dataEnd) -> value0 {
                    value0 := iszero(iszero(calldataload(headStart)))
                }
                let flag := abi_decode_tuple_t_bool(4, calldatasize())
                mstore(0, flag)
            }
        }
    """)

    ir = compile_yul_code(yul_bool)
    # Should contain iszero operations for bool conversion
    assert "iszero" in ir, "Bool type should use iszero conversion"
    print("✓ Bool conversion applied")


def test_mixed_types():
    """Test mixed type patterns."""

    yul_mixed = dedent("""
        object "Test" {
            code {
                function abi_decode_tuple_t_addresst_uint256(headStart, dataEnd) -> addr, amount {
                    addr := and(calldataload(headStart), 0xffffffffffffffffffffffffffffffffffffffff)
                    amount := calldataload(add(headStart, 32))
                }
                let a, b := abi_decode_tuple_t_addresst_uint256(4, calldatasize())
                mstore(0, a)
                mstore(32, b)
            }
        }
    """)

    ir = compile_yul_code(yul_mixed)
    # Should be inlined (only 2 params)
    assert "invoke" not in ir or "@abi_decode" not in ir, "Mixed types with 2 params should be inlined"
    # Should contain masking for address
    assert "and" in ir.lower() or "0xffffffffffffffffffffffffffffffffffffffff" in ir.lower(), "Should mask address"
    print("✓ Mixed type optimization works")


if __name__ == "__main__":
    test_abi_decode_optimization_patterns()
    test_type_specific_optimizations()
    test_mixed_types()
    print("\n✅ All comprehensive ABI decode tests passed!")
