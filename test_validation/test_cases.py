#!/usr/bin/env python3
"""
Test case definitions for contract execution validation.
"""

from typing import Dict, List, Any
from eth_abi import encode
from eth_utils import function_signature_to_4byte_selector

from test_validation.validators.execution_validator import (
    TestCase,
    create_function_calldata,
)


def _normalize_contract_name(name: str) -> str:
    """Normalize contract identifiers so orchestrator lookups succeed."""
    return "".join(ch for ch in name if ch.isalnum()).lower()


def get_test_cases_for_contract(contract_name: str) -> List[TestCase]:
    """
    Get test cases for a specific contract.
    
    Args:
        contract_name: Name of the contract
    
    Returns:
        List of test cases
    """
    normalized = _normalize_contract_name(contract_name)
    if contract_name in TEST_CASES:
        return TEST_CASES[contract_name]
    return NORMALIZED_TEST_CASES.get(normalized, [])


# Define test cases for each contract type
DEFAULT_CALLER = "0x2000000000000000000000000000000000000002"


TEST_CASES = {
    "AdvancedFeatures": [
        TestCase(
            name="deposit_amount_5",
            function_selector=function_signature_to_4byte_selector(
                "deposit(uint256)"
            ).hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("deposit(uint256)").hex(),
                5,
            ),
        ),
        TestCase(
            name="deposit_amount_7",
            function_selector=function_signature_to_4byte_selector(
                "deposit(uint256)"
            ).hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("deposit(uint256)").hex(),
                7,
            ),
        ),
        TestCase(
            name="get_user_after_deposits",
            function_selector=function_signature_to_4byte_selector(
                "getUser(address)"
            ).hex(),
            calldata=function_signature_to_4byte_selector("getUser(address)")
            + encode(["address"], [DEFAULT_CALLER]),
            expected_return=encode(["uint256", "uint256"], [12, 2]),
        ),
        TestCase(
            name="history_sum_after_deposits",
            function_selector=function_signature_to_4byte_selector(
                "historySum()"
            ).hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("historySum()").hex()
            ),
            expected_return=encode(["uint256"], [12]),
        ),
        TestCase(
            name="history_average_after_deposits",
            function_selector=function_signature_to_4byte_selector(
                "historyAverage()"
            ).hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("historyAverage()").hex()
            ),
            expected_return=encode(["uint256"], [6]),
        ),
        TestCase(
            name="withdraw_amount_4",
            function_selector=function_signature_to_4byte_selector(
                "withdraw(uint256)"
            ).hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("withdraw(uint256)").hex(),
                4,
            ),
        ),
        TestCase(
            name="get_user_after_withdraw",
            function_selector=function_signature_to_4byte_selector(
                "getUser(address)"
            ).hex(),
            calldata=function_signature_to_4byte_selector("getUser(address)")
            + encode(["address"], [DEFAULT_CALLER]),
            expected_return=encode(["uint256", "uint256"], [8, 3]),
        ),
        TestCase(
            name="history_sum_after_withdraw",
            function_selector=function_signature_to_4byte_selector(
                "historySum()"
            ).hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("historySum()").hex()
            ),
            expected_return=encode(["uint256"], [12]),
        ),
        TestCase(
            name="factorial_six",
            function_selector=function_signature_to_4byte_selector(
                "factorial(uint256)"
            ).hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("factorial(uint256)").hex(),
                6,
            ),
            expected_return=encode(["uint256"], [720]),
        ),
        TestCase(
            name="fib_seven",
            function_selector=function_signature_to_4byte_selector(
                "fib(uint256)"
            ).hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("fib(uint256)").hex(),
                7,
            ),
            expected_return=encode(["uint256"], [13]),
        ),
    ],

    "SimpleStorage": [
        TestCase(
            name="store_42",
            function_selector=function_signature_to_4byte_selector("store(uint256)").hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("store(uint256)").hex(),
                42
            ),
            expected_storage={0: 42}
        ),
        TestCase(
            name="retrieve_after_store",
            function_selector=function_signature_to_4byte_selector("retrieve()").hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("retrieve()").hex()
            ),
            expected_return=(42).to_bytes(32, byteorder='big')
        ),
        TestCase(
            name="store_0",
            function_selector=function_signature_to_4byte_selector("store(uint256)").hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("store(uint256)").hex(),
                0
            ),
            expected_storage={0: 0}
        ),
        TestCase(
            name="store_max_uint256",
            function_selector=function_signature_to_4byte_selector("store(uint256)").hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("store(uint256)").hex(),
                2**256 - 1
            ),
            expected_storage={0: 2**256 - 1}
        ),
    ],
    
    "arithmetic": [  # Use lowercase to match the test name
        TestCase(
            name="add_5_3",
            function_selector=function_signature_to_4byte_selector("add(uint256,uint256)").hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("add(uint256,uint256)").hex(),
                5, 3
            ),
            expected_return=(8).to_bytes(32, byteorder='big')
        ),
        TestCase(
            name="multiply_4_7",
            function_selector=function_signature_to_4byte_selector("multiply(uint256,uint256)").hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("multiply(uint256,uint256)").hex(),
                4, 7
            ),
            expected_return=(28).to_bytes(32, byteorder='big')
        ),
        TestCase(
            name="add_0_0",
            function_selector=function_signature_to_4byte_selector("add(uint256,uint256)").hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("add(uint256,uint256)").hex(),
                0, 0
            ),
            expected_return=(0).to_bytes(32, byteorder='big')
        ),
        TestCase(
            name="multiply_0_100",
            function_selector=function_signature_to_4byte_selector("multiply(uint256,uint256)").hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("multiply(uint256,uint256)").hex(),
                0, 100
            ),
            expected_return=(0).to_bytes(32, byteorder='big')
        ),
    ],
    
    "BasicMath": [
        TestCase(
            name="set_value_123",
            function_selector=function_signature_to_4byte_selector("setValue(uint256)").hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("setValue(uint256)").hex(),
                123
            ),
            expected_storage={0: 123}
        ),
        TestCase(
            name="get_value_after_set",
            function_selector=function_signature_to_4byte_selector("getValue()").hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("getValue()").hex()
            ),
            expected_return=(123).to_bytes(32, byteorder='big')
        ),
        TestCase(
            name="add_10_20",
            function_selector=function_signature_to_4byte_selector("add(uint256,uint256)").hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("add(uint256,uint256)").hex(),
                10, 20
            ),
            expected_return=(30).to_bytes(32, byteorder='big')
        ),
        TestCase(
            name="multiply_6_7",
            function_selector=function_signature_to_4byte_selector("multiply(uint256,uint256)").hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("multiply(uint256,uint256)").hex(),
                6, 7
            ),
            expected_return=(42).to_bytes(32, byteorder='big')
        ),
    ],
    
    "ControlFlow": [
        TestCase(
            name="for_loop_sum_5",
            function_selector=function_signature_to_4byte_selector("forLoopSum(uint256)").hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("forLoopSum(uint256)").hex(),
                5
            ),
            expected_return=(15).to_bytes(32, byteorder='big')
        ),
        TestCase(
            name="while_factorial_5",
            function_selector=function_signature_to_4byte_selector("whileLoopFactorial(uint256)").hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("whileLoopFactorial(uint256)").hex(),
                5
            ),
            expected_return=(120).to_bytes(32, byteorder='big')
        ),
        TestCase(
            name="require_test_valid",
            function_selector=function_signature_to_4byte_selector("requireTest(uint256)").hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("requireTest(uint256)").hex(),
                10
            ),
            expected_return=(20).to_bytes(32, byteorder='big')
        ),
        TestCase(
            name="require_test_zero_reverts",
            function_selector=function_signature_to_4byte_selector("requireTest(uint256)").hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("requireTest(uint256)").hex(),
                0
            ),
            expected_revert=True
        ),
        TestCase(
            name="require_test_large_reverts",
            function_selector=function_signature_to_4byte_selector("requireTest(uint256)").hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("requireTest(uint256)").hex(),
                5000
            ),
            expected_revert=True
        ),
        TestCase(
            name="nested_loops_3",
            function_selector=function_signature_to_4byte_selector("nestedLoops(uint256)").hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("nestedLoops(uint256)").hex(),
                3
            ),
            expected_return=(9).to_bytes(32, byteorder='big')
        ),
        TestCase(
            name="assert_test_10",
            function_selector=function_signature_to_4byte_selector("assertTest(uint256)").hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("assertTest(uint256)").hex(),
                10
            ),
            expected_return=(20).to_bytes(32, byteorder='big')
        ),
    ],
}


NORMALIZED_TEST_CASES = {
    _normalize_contract_name(name): cases for name, cases in TEST_CASES.items()
}


def get_simple_test_cases() -> List[TestCase]:
    """
    Get simple test cases that work for most contracts.
    These just test basic deployment and simple calls.
    
    Returns:
        List of simple test cases
    """
    return [
        TestCase(
            name="empty_call",
            function_selector=None,
            calldata=b"",
            expected_revert=True  # Default to revert on empty call (no fallback)
        ),
        TestCase(
            name="invalid_selector",
            function_selector="deadbeef",
            calldata=bytes.fromhex("deadbeef"),
            expected_revert=True  # Default to revert for unknown selector
        ),
    ]


def create_custom_test_case(name: str,
                           function_sig: str,
                           args: List[Any],
                           expected_return: Any = None,
                           expected_storage: Dict[int, int] = None,
                           expected_revert: bool = False) -> TestCase:
    """
    Create a custom test case.
    
    Args:
        name: Name of the test
        function_sig: Function signature like "transfer(address,uint256)"
        args: Function arguments
        expected_return: Expected return value
        expected_storage: Expected storage changes
        expected_revert: Whether call should revert
    
    Returns:
        TestCase instance
    """
    selector = function_signature_to_4byte_selector(function_sig).hex()
    calldata = create_function_calldata(selector, *args)
    
    # Convert expected return to bytes if needed
    if expected_return is not None and not isinstance(expected_return, bytes):
        if isinstance(expected_return, int):
            expected_return = expected_return.to_bytes(32, byteorder='big')
    
    return TestCase(
        name=name,
        function_selector=selector,
        calldata=calldata,
        expected_return=expected_return,
        expected_storage=expected_storage,
        expected_revert=expected_revert
    )
