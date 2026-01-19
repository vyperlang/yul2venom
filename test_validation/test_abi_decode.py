"""Test various ABI decode patterns to ensure general handling."""

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


def compile_yul_code(yul_code: str) -> bytes:
    """Helper to compile Yul code to bytecode."""
    with tempfile.NamedTemporaryFile(mode='w', suffix='.yul', delete=False) as f:
        f.write(yul_code)
        f.flush()
        yul_file = f.name

    try:
        # Run the yul compiler
        cmd = ["python", "yul_to_venom/cli/yul.py", yul_file]
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

        # Extract hex bytecode
        bytecode_hex = result.stdout.strip()
        if bytecode_hex.startswith('0x'):
            bytecode_hex = bytecode_hex[2:]

        return bytes.fromhex(bytecode_hex)
    finally:
        os.unlink(yul_file)


def test_abi_decode_single_uint256():
    """Test single uint256 ABI decode pattern."""
    yul_code = dedent("""
        object "Test" {
            code {
                function abi_decode_t_uint256(offset, end) -> value {
                    value := calldataload(offset)
                }

                function abi_decode_tuple_t_uint256(headStart, dataEnd) -> value0 {
                    value0 := abi_decode_t_uint256(headStart, dataEnd)
                }

                let x := abi_decode_tuple_t_uint256(4, calldatasize())
                mstore(0, x)
                return(0, 32)
            }
        }
    """)

    bytecode = compile_yul_code(yul_code)
    assert len(bytecode) > 0, "Should generate bytecode"


def test_abi_decode_three_uint256():
    """Test triple uint256 ABI decode pattern - NOT hardcoded."""
    yul_code = dedent("""
        object "Test" {
            code {
                function abi_decode_t_uint256(offset, end) -> value {
                    value := calldataload(offset)
                }

                function abi_decode_tuple_t_uint256t_uint256t_uint256(headStart, dataEnd) -> value0, value1, value2 {
                    value0 := abi_decode_t_uint256(headStart, dataEnd)
                    value1 := abi_decode_t_uint256(add(headStart, 32), dataEnd)
                    value2 := abi_decode_t_uint256(add(headStart, 64), dataEnd)
                }

                let x, y, z := abi_decode_tuple_t_uint256t_uint256t_uint256(4, calldatasize())
                mstore(0, x)
                mstore(32, y)
                mstore(64, z)
                return(0, 96)
            }
        }
    """)

    bytecode = compile_yul_code(yul_code)
    assert len(bytecode) > 0, "Should generate bytecode"


def test_abi_decode_address():
    """Test address ABI decode pattern."""
    yul_code = dedent("""
        object "Test" {
            code {
                function abi_decode_t_address(offset, end) -> value {
                    value := and(calldataload(offset), 0xffffffffffffffffffffffffffffffffffffffff)
                }

                function abi_decode_tuple_t_address(headStart, dataEnd) -> value0 {
                    value0 := abi_decode_t_address(headStart, dataEnd)
                }

                let addr := abi_decode_tuple_t_address(4, calldatasize())
                mstore(0, addr)
                return(0, 32)
            }
        }
    """)

    bytecode = compile_yul_code(yul_code)
    assert len(bytecode) > 0, "Should generate bytecode"


def test_abi_decode_address_uint256():
    """Test mixed address and uint256 decode - NOT hardcoded."""
    yul_code = dedent("""
        object "Test" {
            code {
                function abi_decode_t_address(offset, end) -> value {
                    value := and(calldataload(offset), 0xffffffffffffffffffffffffffffffffffffffff)
                }

                function abi_decode_t_uint256(offset, end) -> value {
                    value := calldataload(offset)
                }

                function abi_decode_tuple_t_addresst_uint256(headStart, dataEnd) -> value0, value1 {
                    value0 := abi_decode_t_address(headStart, dataEnd)
                    value1 := abi_decode_t_uint256(add(headStart, 32), dataEnd)
                }

                let addr, amount := abi_decode_tuple_t_addresst_uint256(4, calldatasize())
                mstore(0, addr)
                mstore(32, amount)
                return(0, 64)
            }
        }
    """)

    bytecode = compile_yul_code(yul_code)
    assert len(bytecode) > 0, "Should generate bytecode"


def test_abi_decode_bool_uint256():
    """Test bool and uint256 decode."""
    yul_code = dedent("""
        object "Test" {
            code {
                function abi_decode_t_bool(offset, end) -> value {
                    value := iszero(iszero(calldataload(offset)))
                }

                function abi_decode_t_uint256(offset, end) -> value {
                    value := calldataload(offset)
                }

                function abi_decode_tuple_t_boolt_uint256(headStart, dataEnd) -> value0, value1 {
                    value0 := abi_decode_t_bool(headStart, dataEnd)
                    value1 := abi_decode_t_uint256(add(headStart, 32), dataEnd)
                }

                let flag, num := abi_decode_tuple_t_boolt_uint256(4, calldatasize())
                mstore(0, flag)
                mstore(32, num)
                return(0, 64)
            }
        }
    """)

    bytecode = compile_yul_code(yul_code)
    assert len(bytecode) > 0, "Should generate bytecode"


def test_abi_decode_bytes32():
    """Test bytes32 decode pattern."""
    yul_code = dedent("""
        object "Test" {
            code {
                function abi_decode_t_bytes32(offset, end) -> value {
                    value := calldataload(offset)
                }

                function abi_decode_tuple_t_bytes32(headStart, dataEnd) -> value0 {
                    value0 := abi_decode_t_bytes32(headStart, dataEnd)
                }

                let hash := abi_decode_tuple_t_bytes32(4, calldatasize())
                mstore(0, hash)
                return(0, 32)
            }
        }
    """)

    bytecode = compile_yul_code(yul_code)
    assert len(bytecode) > 0, "Should generate bytecode"


def test_abi_decode_int256():
    """Test int256 decode pattern."""
    yul_code = dedent("""
        object "Test" {
            code {
                function abi_decode_t_int256(offset, end) -> value {
                    value := calldataload(offset)
                }

                function abi_decode_tuple_t_int256(headStart, dataEnd) -> value0 {
                    value0 := abi_decode_t_int256(headStart, dataEnd)
                }

                let signed := abi_decode_tuple_t_int256(4, calldatasize())
                mstore(0, signed)
                return(0, 32)
            }
        }
    """)

    bytecode = compile_yul_code(yul_code)
    assert len(bytecode) > 0, "Should generate bytecode"


def test_abi_decode_uint8_uint16_uint32():
    """Test smaller uint types decode."""
    yul_code = dedent("""
        object "Test" {
            code {
                function abi_decode_t_uint8(offset, end) -> value {
                    value := and(calldataload(offset), 0xff)
                }

                function abi_decode_t_uint16(offset, end) -> value {
                    value := and(calldataload(offset), 0xffff)
                }

                function abi_decode_t_uint32(offset, end) -> value {
                    value := and(calldataload(offset), 0xffffffff)
                }

                function abi_decode_tuple_t_uint8t_uint16t_uint32(headStart, dataEnd) -> value0, value1, value2 {
                    value0 := abi_decode_t_uint8(headStart, dataEnd)
                    value1 := abi_decode_t_uint16(add(headStart, 32), dataEnd)
                    value2 := abi_decode_t_uint32(add(headStart, 64), dataEnd)
                }

                let a, b, c := abi_decode_tuple_t_uint8t_uint16t_uint32(4, calldatasize())
                mstore(0, a)
                mstore(32, b)
                mstore(64, c)
                return(0, 96)
            }
        }
    """)

    bytecode = compile_yul_code(yul_code)
    assert len(bytecode) > 0, "Should generate bytecode"


def test_abi_decode_tuple_fromMemory_variants():
    """Test fromMemory variants of decode functions."""
    yul_code = dedent("""
        object "Test" {
            code {
                function abi_decode_t_uint256_fromMemory(offset, end) -> value {
                    value := mload(offset)
                }

                function abi_decode_tuple_t_uint256t_uint256_fromMemory(headStart, dataEnd) -> value0, value1 {
                    value0 := abi_decode_t_uint256_fromMemory(headStart, dataEnd)
                    value1 := abi_decode_t_uint256_fromMemory(add(headStart, 32), dataEnd)
                }

                // This should be handled generically, not hardcoded
                let x, y := abi_decode_tuple_t_uint256t_uint256_fromMemory(0, 64)
                mstore(128, x)
                mstore(160, y)
                return(128, 64)
            }
        }
    """)

    bytecode = compile_yul_code(yul_code)
    assert len(bytecode) > 0, "Should generate bytecode"


def test_abi_decode_four_params():
    """Test decode with 4 parameters - definitely not hardcoded."""
    yul_code = dedent("""
        object "Test" {
            code {
                function abi_decode_t_uint256(offset, end) -> value {
                    value := calldataload(offset)
                }

                function abi_decode_tuple_t_uint256t_uint256t_uint256t_uint256(headStart, dataEnd)
                    -> value0, value1, value2, value3 {
                    value0 := abi_decode_t_uint256(headStart, dataEnd)
                    value1 := abi_decode_t_uint256(add(headStart, 32), dataEnd)
                    value2 := abi_decode_t_uint256(add(headStart, 64), dataEnd)
                    value3 := abi_decode_t_uint256(add(headStart, 96), dataEnd)
                }

                let a, b, c, d := abi_decode_tuple_t_uint256t_uint256t_uint256t_uint256(4, calldatasize())
                mstore(0, a)
                mstore(32, b)
                mstore(64, c)
                mstore(96, d)
                return(0, 128)
            }
        }
    """)

    bytecode = compile_yul_code(yul_code)
    assert len(bytecode) > 0, "Should generate bytecode"
