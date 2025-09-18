#!/usr/bin/env python3
"""
Test case definitions for contract execution validation.
"""

from typing import Dict, List, Any
from test_validation.validators.execution_validator import TestCase, create_function_calldata
from eth_utils import function_signature_to_4byte_selector


def get_test_cases_for_contract(contract_name: str) -> List[TestCase]:
    """
    Get test cases for a specific contract.
    
    Args:
        contract_name: Name of the contract
    
    Returns:
        List of test cases
    """
    test_cases = TEST_CASES.get(contract_name, [])
    return test_cases


# Define test cases for each contract type
TEST_CASES = {
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
            name="add_10_20",
            function_selector=function_signature_to_4byte_selector("add(uint256,uint256)").hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("add(uint256,uint256)").hex(),
                10, 20
            ),
            expected_return=(30).to_bytes(32, byteorder='big')
        ),
        TestCase(
            name="subtract_50_20",
            function_selector=function_signature_to_4byte_selector("subtract(uint256,uint256)").hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("subtract(uint256,uint256)").hex(),
                50, 20
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
        TestCase(
            name="divide_100_5",
            function_selector=function_signature_to_4byte_selector("divide(uint256,uint256)").hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("divide(uint256,uint256)").hex(),
                100, 5
            ),
            expected_return=(20).to_bytes(32, byteorder='big')
        ),
    ],
    
    "ControlFlow": [
        TestCase(
            name="max_10_5",
            function_selector=function_signature_to_4byte_selector("max(uint256,uint256)").hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("max(uint256,uint256)").hex(),
                10, 5
            ),
            expected_return=(10).to_bytes(32, byteorder='big')
        ),
        TestCase(
            name="max_3_8",
            function_selector=function_signature_to_4byte_selector("max(uint256,uint256)").hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("max(uint256,uint256)").hex(),
                3, 8
            ),
            expected_return=(8).to_bytes(32, byteorder='big')
        ),
        TestCase(
            name="max_equal",
            function_selector=function_signature_to_4byte_selector("max(uint256,uint256)").hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("max(uint256,uint256)").hex(),
                7, 7
            ),
            expected_return=(7).to_bytes(32, byteorder='big')
        ),
        TestCase(
            name="fibonacci_0",
            function_selector=function_signature_to_4byte_selector("fibonacci(uint256)").hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("fibonacci(uint256)").hex(),
                0
            ),
            expected_return=(0).to_bytes(32, byteorder='big')
        ),
        TestCase(
            name="fibonacci_1",
            function_selector=function_signature_to_4byte_selector("fibonacci(uint256)").hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("fibonacci(uint256)").hex(),
                1
            ),
            expected_return=(1).to_bytes(32, byteorder='big')
        ),
        TestCase(
            name="fibonacci_5",
            function_selector=function_signature_to_4byte_selector("fibonacci(uint256)").hex(),
            calldata=create_function_calldata(
                function_signature_to_4byte_selector("fibonacci(uint256)").hex(),
                5
            ),
            expected_return=(5).to_bytes(32, byteorder='big')
        ),
    ],
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
