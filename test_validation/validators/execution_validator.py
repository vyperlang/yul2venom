#!/usr/bin/env python3
"""
Execution-based validation framework for comparing Solidity and Yul-transpiled bytecode.
Uses pyrevm to execute bytecode and compare actual behavior rather than superficial properties.
"""

from typing import Dict, List, Tuple, Optional, Any
from dataclasses import dataclass
from enum import Enum
from pyrevm import EVM, Env
from eth_utils import to_checksum_address, to_hex, to_bytes, keccak


class ValidationResult(Enum):
    """Validation result status."""
    PASS = "pass"
    FAIL = "fail"
    ERROR = "error"


@dataclass
class ExecutionReport:
    """Report for a single execution test."""
    test_name: str
    status: ValidationResult
    message: str
    details: Dict[str, Any]
    
    def __str__(self):
        return f"[{self.status.value.upper()}] {self.test_name}: {self.message}"


@dataclass
class TestCase:
    """Definition of a test case for contract execution."""
    name: str
    function_selector: Optional[str]  # 4-byte function selector (optional)
    calldata: bytes  # Full calldata to send
    value: int = 0  # Wei to send with transaction
    expected_return: Optional[bytes] = None  # Expected return data
    expected_storage: Optional[Dict[int, int]] = None  # Expected storage changes
    expected_revert: bool = False  # Whether call should revert
    gas_limit: int = 1_000_000  # Gas limit for execution


class ExecutionValidator:
    """Validator for comparing bytecode outputs through actual execution."""
    
    def __init__(self):
        """Initialize the ExecutionValidator with pyrevm."""
        self.evm = EVM()
        # pyrevm has default block environment, we can use it as is
    
    def deploy_contract(
        self,
        bytecode: str,
        deployer: str = None,
        constructor_args: bytes = b"",
    ) -> Tuple[bool, str, bytes]:
        """
        Deploy a contract and return its address.
        
        Args:
            bytecode: Hex string of deployment bytecode
            deployer: Address of deployer (optional)
        
        Returns:
            Tuple of (success, contract_address, output_data)
        """
        if deployer is None:
            deployer = "0x1000000000000000000000000000000000000001"
        
        # Ensure deployer has balance
        self.evm.set_balance(deployer, 10**18)  # 1 ETH
        
        # Remove 0x prefix if present
        if bytecode.startswith("0x"):
            bytecode = bytecode[2:]
        
        # Deploy the contract
        try:
            # Append constructor args (standard: appended to initcode)
            code_bytes = bytes.fromhex(bytecode) + (constructor_args or b"")
            contract_address = self.evm.deploy(
                deployer=deployer,
                code=code_bytes,
                value=0,
                gas=5_000_000
            )
            
            if contract_address:
                # Get the deployed contract address
                contract_address = to_checksum_address(contract_address)
                return True, contract_address, b""
            else:
                return False, None, b"No address returned"
        except Exception as e:
            # Include the error message for debugging
            return False, None, f"Deployment error: {str(e)}".encode()
    
    def execute_call(self, 
                    contract_address: str, 
                    calldata: bytes,
                    caller: str = None,
                    value: int = 0,
                    gas_limit: int = 1_000_000) -> Tuple[bool, bytes, Dict[int, int]]:
        """
        Execute a call to a contract.
        
        Args:
            contract_address: Address of the contract
            calldata: Calldata to send
            caller: Address of caller (optional)
            value: Wei to send
            gas_limit: Gas limit for execution
        
        Returns:
            Tuple of (success, return_data, storage_changes)
        """
        if caller is None:
            caller = "0x2000000000000000000000000000000000000002"
        
        # Ensure caller has balance if sending value
        if value > 0:
            self.evm.set_balance(caller, value + 10**18)
        
        # Take a snapshot of storage before the call
        storage_before = {}
        for i in range(10):  # Check first 10 storage slots
            storage_val = self.evm.storage(contract_address, i)
            storage_before[i] = storage_val if storage_val is not None else 0
        
        # Execute the call
        try:
            output = self.evm.message_call(
                caller=caller,
                to=contract_address,
                calldata=calldata,
                value=value,
                gas=gas_limit,
                is_static=False,
            )
            success = True
        except Exception:
            output = b""
            success = False
        
        # Get storage after the call
        storage_after = {}
        storage_changes = {}
        for i in range(10):
            storage_val = self.evm.storage(contract_address, i)
            storage_after[i] = storage_val if storage_val is not None else 0
            if storage_before[i] != storage_after[i]:
                storage_changes[i] = storage_after[i]
        
        return success, output if output else b"", storage_changes
    
    def validate_execution(
        self,
        original_bytecode: str,
        transpiled_bytecode: str,
        test_cases: List[TestCase],
        constructor_args: bytes = b"",
    ) -> List[ExecutionReport]:
        """
        Validate that two bytecodes behave identically.
        
        Args:
            original_bytecode: Original deployment bytecode
            transpiled_bytecode: Transpiled deployment bytecode
            test_cases: List of test cases to execute
        
        Returns:
            List of ExecutionReports
        """
        reports = []
        
        # Deploy both contracts in separate EVM instances
        success1, addr1, deploy_output1 = self.deploy_contract(
            original_bytecode, constructor_args=constructor_args
        )
        if not success1:
            reports.append(ExecutionReport(
                test_name="deployment",
                status=ValidationResult.ERROR,
                message="Failed to deploy original contract",
                details={"output": to_hex(deploy_output1) if deploy_output1 else None}
            ))
            return reports
        
        # Keep a handle to the original EVM
        evm_original = self.evm

        # Use a fresh EVM for the transpiled contract
        self.evm = EVM()
        success2, addr2, deploy_output2 = self.deploy_contract(
            transpiled_bytecode, constructor_args=constructor_args
        )
        if not success2:
            error_msg = deploy_output2.decode('utf-8', errors='replace') if deploy_output2 else "Unknown error"
            reports.append(ExecutionReport(
                test_name="deployment",
                status=ValidationResult.ERROR,
                message=f"Failed to deploy transpiled contract: {error_msg}",
                details={"output": to_hex(deploy_output2) if deploy_output2 else None, "error": error_msg}
            ))
            return reports
        
        reports.append(ExecutionReport(
            test_name="deployment",
            status=ValidationResult.PASS,
            message="Both contracts deployed successfully",
            details={
                "original_address": addr1,
                "transpiled_address": addr2
            }
        ))
        
        # Keep a handle to the transpiled EVM
        evm_transpiled = self.evm

        # Execute test cases on both contracts using their respective EVMs
        for test_case in test_cases:
            # Note: pyrevm doesn't have a direct way to clear storage
            # Each test runs with the accumulated state
            
            # Execute on original
            # Original
            self.evm = evm_original
            success1, output1, storage1 = self.execute_call(
                addr1, 
                test_case.calldata,
                value=test_case.value,
                gas_limit=test_case.gas_limit
            )
            
            # Transpiled
            self.evm = evm_transpiled
            success2, output2, storage2 = self.execute_call(
                addr2,
                test_case.calldata,
                value=test_case.value,
                gas_limit=test_case.gas_limit
            )
            
            # Compare results
            if success1 != success2:
                status = ValidationResult.FAIL
                message = f"Execution success mismatch: original={success1}, transpiled={success2}"
            elif test_case.expected_revert and not success1:
                status = ValidationResult.PASS
                message = "Both contracts reverted as expected"
            elif not test_case.expected_revert and not success1:
                status = ValidationResult.ERROR
                message = "Unexpected revert in both contracts"
            elif output1 != output2:
                status = ValidationResult.FAIL
                message = f"Output mismatch"
            elif storage1 != storage2:
                status = ValidationResult.FAIL
                message = f"Storage mismatch"
            elif test_case.expected_return is not None and output1 != test_case.expected_return:
                status = ValidationResult.FAIL
                message = f"Output differs from expected"
            elif test_case.expected_storage is not None:
                storage_matches = all(
                    storage1.get(slot, 0) == expected
                    for slot, expected in test_case.expected_storage.items()
                )
                if not storage_matches:
                    status = ValidationResult.FAIL
                    message = "Storage differs from expected"
                else:
                    status = ValidationResult.PASS
                    message = "Execution matched perfectly"
            else:
                status = ValidationResult.PASS
                message = "Execution matched perfectly"
            
            reports.append(ExecutionReport(
                test_name=test_case.name,
                status=status,
                message=message,
                details={
                    "original_success": success1,
                    "transpiled_success": success2,
                    "original_output": to_hex(output1) if output1 else None,
                    "transpiled_output": to_hex(output2) if output2 else None,
                    "original_storage": storage1,
                    "transpiled_storage": storage2
                }
            ))
        
        return reports
    
    def validate_simple_bytecode(self, original: str, transpiled: str) -> ExecutionReport:
        """
        Simple validation for bytecode without specific test cases.
        Just deploys and checks if both can be deployed successfully.
        
        Args:
            original: Original bytecode
            transpiled: Transpiled bytecode
        
        Returns:
            ExecutionReport
        """
        # Reset EVM
        self.evm = EVM()
        
        success1, addr1, output1 = self.deploy_contract(original)
        
        # Reset for second deployment
        self.evm = EVM()
        
        success2, addr2, output2 = self.deploy_contract(transpiled)
        
        if success1 and success2:
            return ExecutionReport(
                test_name="simple_deployment",
                status=ValidationResult.PASS,
                message="Both contracts deployed successfully",
                details={
                    "original_deployed": success1,
                    "transpiled_deployed": success2
                }
            )
        elif success1 != success2:
            return ExecutionReport(
                test_name="simple_deployment",
                status=ValidationResult.FAIL,
                message=f"Deployment mismatch: original={success1}, transpiled={success2}",
                details={
                    "original_deployed": success1,
                    "transpiled_deployed": success2,
                    "original_output": to_hex(output1) if output1 else None,
                    "transpiled_output": to_hex(output2) if output2 else None
                }
            )
        else:
            return ExecutionReport(
                test_name="simple_deployment",
                status=ValidationResult.ERROR,
                message="Both contracts failed to deploy",
                details={
                    "original_output": to_hex(output1) if output1 else None,
                    "transpiled_output": to_hex(output2) if output2 else None
                }
            )


def create_function_calldata(selector: str, *args) -> bytes:
    """
    Helper to create calldata for a function call.
    
    Args:
        selector: 4-byte function selector as hex string
        args: Arguments encoded as bytes
    
    Returns:
        Complete calldata
    """
    if selector.startswith("0x"):
        selector = selector[2:]
    
    calldata = bytes.fromhex(selector)
    for arg in args:
        if isinstance(arg, int):
            # Encode as uint256
            calldata += arg.to_bytes(32, byteorder='big')
        elif isinstance(arg, bytes):
            calldata += arg
        elif isinstance(arg, str) and arg.startswith("0x"):
            calldata += bytes.fromhex(arg[2:])
    
    return calldata
