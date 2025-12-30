"""Load test configuration from YAML."""

from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Dict, List, Optional

import yaml
from eth_abi import encode
from eth_utils import function_signature_to_4byte_selector

from test_validation.exceptions import ConfigurationError
from test_validation.validators.execution_validator import (
    TestCase,
    create_function_calldata,
)


@dataclass
class ExecutionTest:
    """Execution test definition from YAML."""
    name: str
    function: Optional[str] = None
    args: List[Any] = field(default_factory=list)
    args_types: Optional[List[str]] = None
    calldata: Optional[str] = None
    expected_return_int: Optional[int] = None
    expected_return_hex: Optional[str] = None
    expected_return_abi: Optional[Dict[str, Any]] = None
    expected_storage: Optional[Dict[int, int]] = None
    expected_revert: bool = False


@dataclass
class TestDefinition:
    """Test definition from YAML."""
    id: str
    file: str
    description: str
    tags: List[str] = field(default_factory=list)
    skip_reason: Optional[str] = None
    test_case_key: Optional[str] = None
    execution_tests: List[ExecutionTest] = field(default_factory=list)
    fork_chain_id: Optional[int] = None  # Chain ID to fork (e.g., 1 for mainnet)


@dataclass
class TestConfig:
    """Complete test configuration."""
    tests: List[TestDefinition]
    default_tests: List[ExecutionTest]
    default_caller: str
    exclude_files: List[str] = field(default_factory=list)


_config_cache: Optional[TestConfig] = None


def _get_config_path() -> Path:
    """Get path to the tests.yaml config file."""
    return Path(__file__).parent / "tests.yaml"


def _parse_execution_test(data: Dict[str, Any]) -> ExecutionTest:
    """Parse a single execution test from YAML data."""
    return ExecutionTest(
        name=data["name"],
        function=data.get("function"),
        args=data.get("args", []),
        args_types=data.get("args_types"),
        calldata=data.get("calldata"),
        expected_return_int=data.get("expected_return_int"),
        expected_return_hex=data.get("expected_return_hex"),
        expected_return_abi=data.get("expected_return_abi"),
        expected_storage=data.get("expected_storage"),
        expected_revert=data.get("expected_revert", False),
    )


def _parse_test_definition(data: Dict[str, Any]) -> TestDefinition:
    """Parse a test definition from YAML data."""
    execution_tests = [
        _parse_execution_test(et)
        for et in data.get("execution_tests", [])
    ]
    return TestDefinition(
        id=data["id"],
        file=data["file"],
        description=data["description"],
        tags=data.get("tags", []),
        skip_reason=data.get("skip_reason"),
        test_case_key=data.get("test_case_key"),
        execution_tests=execution_tests,
        fork_chain_id=data.get("fork_chain_id"),
    )


def load_test_config(force_reload: bool = False) -> TestConfig:
    """
    Load test configuration from YAML.

    Args:
        force_reload: Force reload from disk even if cached.

    Returns:
        TestConfig with all test definitions.
    """
    global _config_cache

    if _config_cache is not None and not force_reload:
        return _config_cache

    config_path = _get_config_path()
    try:
        with open(config_path) as f:
            data = yaml.safe_load(f)
    except (OSError, yaml.YAMLError) as e:
        raise ConfigurationError(f"Failed to load test configuration from {config_path}: {e}")

    try:
        tests = [_parse_test_definition(td) for td in data.get("tests", [])]
        default_tests = [
            _parse_execution_test(dt)
            for dt in data.get("default_tests", [])
        ]
        default_caller = data.get(
            "default_caller",
            "0x2000000000000000000000000000000000000002"
        )
        exclude_files = data.get("exclude_files", [])
    except (KeyError, TypeError, ValueError) as e:
        raise ConfigurationError(f"Invalid test configuration format: {e}")

    _config_cache = TestConfig(
        tests=tests,
        default_tests=default_tests,
        default_caller=default_caller,
        exclude_files=exclude_files,
    )
    return _config_cache


def get_test_definitions() -> List[TestDefinition]:
    """Get all test definitions (non-skipped)."""
    config = load_test_config()
    return [t for t in config.tests if not t.skip_reason]


def get_skip_tests() -> Dict[str, str]:
    """Get map of skipped test IDs to skip reasons."""
    config = load_test_config()
    return {
        t.id: t.skip_reason
        for t in config.tests
        if t.skip_reason
    }


def get_excluded_files() -> List[str]:
    """Get list of files to exclude from test discovery (library-only files)."""
    config = load_test_config()
    return config.exclude_files


def _execution_test_to_testcase(
    et: ExecutionTest,
    default_caller: str,
) -> TestCase:
    """Convert an ExecutionTest to a TestCase for execution."""
    # Handle raw calldata (for default tests)
    if et.calldata is not None:
        calldata = bytes.fromhex(et.calldata) if et.calldata else b""
        selector = et.calldata[:8] if len(et.calldata) >= 8 else None
        return TestCase(
            name=et.name,
            function_selector=selector,
            calldata=calldata,
            expected_revert=et.expected_revert,
        )

    # Build calldata from function signature
    if et.function is None:
        raise ConfigurationError(f"ExecutionTest {et.name} has no function or calldata")

    selector = function_signature_to_4byte_selector(et.function)
    selector_hex = selector.hex()

    # Handle args with explicit types (for address, etc.)
    if et.args_types:
        # Use explicit types for encoding
        encoded_args = encode(et.args_types, et.args)
        calldata = selector + encoded_args
    elif et.args:
        # Infer types from function signature
        calldata = create_function_calldata(selector_hex, *et.args)
    else:
        calldata = selector

    # Build expected return value
    expected_return: Optional[bytes] = None
    if et.expected_return_int is not None:
        expected_return = et.expected_return_int.to_bytes(32, byteorder="big")
    elif et.expected_return_hex is not None:
        expected_return = bytes.fromhex(et.expected_return_hex.lstrip("0x"))
    elif et.expected_return_abi is not None:
        types = et.expected_return_abi["types"]
        values = et.expected_return_abi["values"]
        expected_return = encode(types, values)

    return TestCase(
        name=et.name,
        function_selector=selector_hex,
        calldata=calldata,
        expected_return=expected_return,
        expected_storage=et.expected_storage,
        expected_revert=et.expected_revert,
    )


def _normalize_name(name: str) -> str:
    """Normalize contract name for lookup."""
    return "".join(ch for ch in name if ch.isalnum()).lower()


def get_execution_tests(contract_name: str) -> List[TestCase]:
    """
    Get execution test cases for a contract.

    Args:
        contract_name: Name of the contract (case-insensitive).

    Returns:
        List of TestCase objects for execution.
    """
    config = load_test_config()
    normalized = _normalize_name(contract_name)

    # Find matching test definition
    for td in config.tests:
        # Check direct ID match
        if td.id == contract_name:
            break
        # Check test_case_key match
        if td.test_case_key and td.test_case_key == contract_name:
            break
        # Check normalized ID match
        if _normalize_name(td.id) == normalized:
            break
        # Check normalized test_case_key match
        if td.test_case_key and _normalize_name(td.test_case_key) == normalized:
            break
    else:
        # No matching definition found
        return []

    if td.skip_reason:
        return []

    return [
        _execution_test_to_testcase(et, config.default_caller)
        for et in td.execution_tests
    ]


def get_default_tests() -> List[TestCase]:
    """Get default test cases for contracts without specific tests."""
    config = load_test_config()
    return [
        _execution_test_to_testcase(et, config.default_caller)
        for et in config.default_tests
    ]
