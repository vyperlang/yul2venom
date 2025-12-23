"""Utilities for hex string handling."""


def strip_0x(hex_str: str) -> str:
    """Remove 0x prefix if present."""
    if hex_str.startswith("0x") or hex_str.startswith("0X"):
        return hex_str[2:]
    return hex_str


def ensure_0x(hex_str: str) -> str:
    """Ensure 0x prefix is present."""
    if not hex_str.startswith("0x"):
        return "0x" + hex_str
    return hex_str


def hex_to_bytes(hex_str: str) -> bytes:
    """Convert hex string to bytes, handling 0x prefix."""
    return bytes.fromhex(strip_0x(hex_str))


def bytes_to_hex(data: bytes, with_prefix: bool = True) -> str:
    """Convert bytes to hex string."""
    hex_str = data.hex()
    return f"0x{hex_str}" if with_prefix else hex_str


def hex_length_bytes(hex_str: str) -> int:
    """Get byte length of hex string."""
    return len(strip_0x(hex_str)) // 2
