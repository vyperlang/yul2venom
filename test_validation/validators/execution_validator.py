#!/usr/bin/env python3
"""
Execution-based validation framework for comparing Solidity and Yul-transpiled bytecode.
Uses pyrevm to execute bytecode and compare actual behavior rather than superficial properties.
"""

from typing import Any, Callable, Dict, List, Optional, Sequence, Tuple
from dataclasses import dataclass
from enum import Enum

from pyrevm import EVM, Env, CfgEnv
from eth_utils import keccak, to_bytes, to_checksum_address, to_hex

# Use local devnet chain_id to avoid mainnet-specific checks in contracts
DEFAULT_CHAIN_ID = 31337

# Mainnet chain_id for fork mode
MAINNET_CHAIN_ID = 1


def _create_evm(fork_url: Optional[str] = None) -> EVM:
    """Create an EVM instance with the configured chain_id.

    Args:
        fork_url: Optional RPC endpoint to fork mainnet state from.
                  When provided, uses mainnet chain_id and lazy-loads state.
    """
    if fork_url:
        return EVM(
            fork_url=fork_url,
            env=Env(cfg=CfgEnv(chain_id=MAINNET_CHAIN_ID))
        )
    return EVM(env=Env(cfg=CfgEnv(chain_id=DEFAULT_CHAIN_ID)))


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
class ExecutionResult:
    """Result of executing a transaction."""
    success: bool
    output: bytes
    gas_used: int
    storage_changes: Dict[int, int]
    logs: List[Any]


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


TestCase.__test__ = False


@dataclass
class DeploymentStep:
    """A single deployment action within a contract deployment plan."""

    name: str
    bytecode_builder: Callable[[Dict[str, str]], str]
    constructor_args: bytes = b""
    dependencies: Tuple[str, ...] = ()


class ExecutionValidator:
    """Validator for comparing bytecode outputs through actual execution."""

    def __init__(self, fork_url: Optional[str] = None):
        """Initialize the ExecutionValidator with pyrevm.

        Args:
            fork_url: Optional RPC endpoint to fork mainnet state from.
        """
        self.fork_url = fork_url
        self.evm = _create_evm(fork_url)
    
    def deploy_contract(
        self,
        bytecode: str,
        deployer: str = None,
        constructor_args: bytes = b"",
    ) -> Tuple[bool, Optional[str], bytes, Optional[int]]:
        """
        Deploy a contract and return its address.
        
        Args:
            bytecode: Hex string of deployment bytecode
            deployer: Address of deployer (optional)
        
        Returns:
            Tuple of (success, contract_address, output_data, gas_used)
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
            exec_result = getattr(self.evm, "result", None)
            gas_used = exec_result.gas_used if exec_result is not None else None

            if contract_address:
                # Get the deployed contract address
                contract_address = to_checksum_address(contract_address)
                return True, contract_address, b"", gas_used
            else:
                return False, None, b"No address returned", gas_used
        except Exception as e:
            # Include the error message for debugging
            exec_result = getattr(self.evm, "result", None)
            gas_used = exec_result.gas_used if exec_result is not None else None
            return False, None, f"Deployment error: {str(e)}".encode(), gas_used
    
    def execute_call(
        self,
        contract_address: str,
        calldata: bytes,
        caller: str = None,
        value: int = 0,
        gas_limit: int = 1_000_000,
    ) -> Tuple[bool, bytes, Dict[int, int], Optional[int]]:
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
            exec_result = getattr(self.evm, "result", None)
            gas_used = exec_result.gas_used if exec_result is not None else None
            success = True
        except Exception:
            output = b""
            success = False
            exec_result = getattr(self.evm, "result", None)
            gas_used = exec_result.gas_used if exec_result is not None else None
        
        # Get storage after the call
        storage_after = {}
        storage_changes = {}
        for i in range(10):
            storage_val = self.evm.storage(contract_address, i)
            storage_after[i] = storage_val if storage_val is not None else 0
            if storage_before[i] != storage_after[i]:
                storage_changes[i] = storage_after[i]
        
        return success, output if output else b"", storage_changes, gas_used

    def call_function(
        self,
        contract_address: str,
        function_sig: str,
        args: List[Any] = None,
        caller: str = None,
        value: int = 0,
        gas_limit: int = 1_000_000,
    ) -> ExecutionResult:
        """
        Call a contract function with signature parsing.

        Args:
            contract_address: Address of the contract
            function_sig: Function signature like "transfer(address,uint256)"
            args: Function arguments
            caller: Name or address of caller
            value: Wei to send
            gas_limit: Gas limit for execution

        Returns:
            ExecutionResult with success, output, gas_used, storage_changes, logs
        """
        from eth_utils import function_signature_to_4byte_selector

        # Map named accounts to addresses
        account_map = {
            "deployer": "0x1000000000000000000000000000000000000001",
            "alice": "0x2000000000000000000000000000000000000002",
            "bob": "0x3000000000000000000000000000000000000003",
        }

        if caller is None:
            caller = "0x2000000000000000000000000000000000000002"
        else:
            caller = account_map.get(caller, caller)

        # Create calldata
        if function_sig:
            selector = function_signature_to_4byte_selector(function_sig)
            calldata = selector

            if args:
                for arg in args:
                    if isinstance(arg, int):
                        calldata += arg.to_bytes(32, byteorder='big')
                    elif isinstance(arg, str) and len(arg) == 42:
                        addr_bytes = bytes.fromhex(arg[2:] if arg.startswith("0x") else arg)
                        calldata += b'\x00' * 12 + addr_bytes
                    elif isinstance(arg, bytes):
                        calldata += arg
        else:
            calldata = b""

        success, output, storage_changes, gas_used = self.execute_call(
            contract_address, calldata, caller, value, gas_limit
        )

        return ExecutionResult(
            success=success,
            output=output,
            gas_used=gas_used or 0,
            storage_changes=storage_changes,
            logs=[]
        )

    def call_contract(
        self,
        contract_address: str,
        calldata: bytes,
        caller: str = None,
        value: int = 0,
        gas_limit: int = 1_000_000,
    ) -> ExecutionResult:
        """
        Call a contract with raw calldata.

        Args:
            contract_address: Address of the contract
            calldata: Raw calldata bytes
            caller: Name or address of caller
            value: Wei to send
            gas_limit: Gas limit for execution

        Returns:
            ExecutionResult with success, output, gas_used, storage_changes, logs
        """
        # Map named accounts to addresses
        account_map = {
            "deployer": "0x1000000000000000000000000000000000000001",
            "alice": "0x2000000000000000000000000000000000000002",
            "bob": "0x3000000000000000000000000000000000000003",
        }

        if caller is None:
            caller = "0x2000000000000000000000000000000000000002"
        else:
            caller = account_map.get(caller, caller)

        success, output, storage_changes, gas_used = self.execute_call(
            contract_address, calldata, caller, value, gas_limit
        )

        return ExecutionResult(
            success=success,
            output=output,
            gas_used=gas_used or 0,
            storage_changes=storage_changes,
            logs=[]
        )

    def _deploy_plan(
        self,
        plan: Sequence[DeploymentStep],
        label: str,
    ) -> Tuple[bool, Dict[str, str], Dict[str, Optional[int]], List[ExecutionReport]]:
        """Deploy each step in a plan sequentially and record results."""

        addresses: Dict[str, str] = {}
        gas_usage: Dict[str, Optional[int]] = {}
        reports: List[ExecutionReport] = []

        for step in plan:
            try:
                bytecode = step.bytecode_builder(addresses)
            except Exception as exc:  # pragma: no cover - defensive
                reports.append(
                    ExecutionReport(
                        test_name=f"deploy[{label}]::{step.name}",
                        status=ValidationResult.ERROR,
                        message=f"Failed to construct bytecode: {exc}",
                        details={
                            "dependencies": step.dependencies,
                        },
                    )
                )
                return False, addresses, gas_usage, reports

            if isinstance(bytecode, bytes):
                bytecode = "0x" + bytecode.hex()
            if not isinstance(bytecode, str):  # pragma: no cover - defensive
                bytecode = str(bytecode)
            if not bytecode.startswith("0x"):
                bytecode = "0x" + bytecode

            success, addr, output, gas_used = self.deploy_contract(
                bytecode, constructor_args=step.constructor_args
            )
            gas_usage[step.name] = gas_used

            bytecode_body = bytecode[2:] if bytecode.startswith("0x") else bytecode

            details = {
                "bytecode_length": len(bytecode_body) // 2,
                "dependencies": step.dependencies,
                "gas_used": gas_used,
            }

            if output:
                details["output"] = (
                    output.decode("utf-8", errors="replace")
                    if isinstance(output, (bytes, bytearray))
                    else output
                )

            if success and addr:
                addresses[step.name] = addr
                details["contract_address"] = addr
                reports.append(
                    ExecutionReport(
                        test_name=f"deploy[{label}]::{step.name}",
                        status=ValidationResult.PASS,
                        message="Deployment succeeded",
                        details=details,
                    )
                )
            else:
                reports.append(
                    ExecutionReport(
                        test_name=f"deploy[{label}]::{step.name}",
                        status=ValidationResult.ERROR,
                        message="Deployment failed",
                        details=details,
                    )
                )
                return False, addresses, gas_usage, reports

        return True, addresses, gas_usage, reports

    def validate_execution_from_plans(
        self,
        original_plan: Sequence[DeploymentStep],
        transpiled_plan: Sequence[DeploymentStep],
        target_name: str,
        test_cases: List[TestCase],
    ) -> List[ExecutionReport]:
        """Validate two deployment plans by executing paired test cases."""

        step_reports: List[ExecutionReport] = []

        # Deploy original plan
        self.evm = _create_evm(self.fork_url)
        success_orig, orig_addresses, orig_gas, orig_reports = self._deploy_plan(
            original_plan, label="original"
        )
        step_reports.extend(orig_reports)
        if not success_orig or target_name not in orig_addresses:
            details = orig_reports[-1].details if orig_reports else {}
            message = (
                f"Target contract '{target_name}' was not deployed in original plan"
                if target_name not in orig_addresses
                else "Failed to deploy original contract"
            )
            summary = ExecutionReport(
                test_name="deployment",
                status=ValidationResult.ERROR,
                message=message,
                details={"plan": "original", **(details or {})},
            )
            return [summary, *step_reports]

        evm_original = self.evm

        # Deploy transpiled plan
        self.evm = _create_evm(self.fork_url)
        success_transp, transp_addresses, transp_gas, transp_reports = self._deploy_plan(
            transpiled_plan, label="transpiled"
        )
        step_reports.extend(transp_reports)
        if not success_transp or target_name not in transp_addresses:
            details = transp_reports[-1].details if transp_reports else {}
            message = (
                f"Target contract '{target_name}' was not deployed in transpiled plan"
                if target_name not in transp_addresses
                else "Failed to deploy transpiled contract"
            )
            summary = ExecutionReport(
                test_name="deployment",
                status=ValidationResult.ERROR,
                message=message,
                details={"plan": "transpiled", **(details or {})},
            )
            return [summary, *step_reports]

        evm_transpiled = self.evm

        summary = ExecutionReport(
            test_name="deployment",
            status=ValidationResult.PASS,
            message="Both deployment plans executed successfully",
            details={
                "original_address": orig_addresses[target_name],
                "transpiled_address": transp_addresses[target_name],
                "original_gas_used": orig_gas.get(target_name),
                "transpiled_gas_used": transp_gas.get(target_name),
            },
        )
        all_reports: List[ExecutionReport] = [summary, *step_reports]

        # Execute test cases on both contracts using their respective EVMs
        for test_case in test_cases:
            self.evm = evm_original
            success1, output1, storage1, gas_used1 = self.execute_call(
                orig_addresses[target_name],
                test_case.calldata,
                value=test_case.value,
                gas_limit=test_case.gas_limit,
            )

            self.evm = evm_transpiled
            success2, output2, storage2, gas_used2 = self.execute_call(
                transp_addresses[target_name],
                test_case.calldata,
                value=test_case.value,
                gas_limit=test_case.gas_limit,
            )

            if success1 != success2:
                status = ValidationResult.FAIL
                message = (
                    f"Execution success mismatch: original={success1}, transpiled={success2}"
                )
            elif test_case.expected_revert and not success1:
                status = ValidationResult.PASS
                message = "Both contracts reverted as expected"
            elif not test_case.expected_revert and not success1:
                status = ValidationResult.ERROR
                message = "Unexpected revert in both contracts"
            elif output1 != output2:
                status = ValidationResult.FAIL
                message = "Output mismatch"
            elif storage1 != storage2:
                status = ValidationResult.FAIL
                message = "Storage mismatch"
            elif (
                test_case.expected_return is not None
                and output1 != test_case.expected_return
            ):
                status = ValidationResult.FAIL
                message = "Output differs from expected"
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

            all_reports.append(
                ExecutionReport(
                    test_name=test_case.name,
                    status=status,
                    message=message,
                    details={
                        "original_success": success1,
                        "transpiled_success": success2,
                        "original_output": to_hex(output1) if output1 else None,
                        "transpiled_output": to_hex(output2) if output2 else None,
                        "original_storage": storage1,
                        "transpiled_storage": storage2,
                        "original_gas_used": gas_used1,
                        "transpiled_gas_used": gas_used2,
                    },
                )
            )

        return all_reports

    def validate_execution(
        self,
        original_bytecode: str,
        transpiled_bytecode: str,
        test_cases: List[TestCase],
        constructor_args: bytes = b"",
    ) -> List[ExecutionReport]:
        """
        Validate that two bytecodes behave identically (compat wrapper).
        """

        target_name = "__target__"

        original_plan = [
            DeploymentStep(
                name=target_name,
                bytecode_builder=lambda _addresses: original_bytecode,
                constructor_args=constructor_args,
            )
        ]
        transpiled_plan = [
            DeploymentStep(
                name=target_name,
                bytecode_builder=lambda _addresses: transpiled_bytecode,
                constructor_args=constructor_args,
            )
        ]

        return self.validate_execution_from_plans(
            original_plan,
            transpiled_plan,
            target_name=target_name,
            test_cases=test_cases,
        )
    
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
        self.evm = _create_evm(self.fork_url)

        success1, addr1, output1, gas1 = self.deploy_contract(original)

        # Reset for second deployment
        self.evm = _create_evm(self.fork_url)

        success2, addr2, output2, gas2 = self.deploy_contract(transpiled)

        if success1 and success2:
            return ExecutionReport(
                test_name="simple_deployment",
                status=ValidationResult.PASS,
                message="Both contracts deployed successfully",
                details={
                    "original_deployed": success1,
                    "transpiled_deployed": success2,
                    "original_gas_used": gas1,
                    "transpiled_gas_used": gas2,
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
                    "transpiled_output": to_hex(output2) if output2 else None,
                    "original_gas_used": gas1,
                    "transpiled_gas_used": gas2,
                }
            )
        else:
            return ExecutionReport(
                test_name="simple_deployment",
                status=ValidationResult.ERROR,
                message="Both contracts failed to deploy",
                details={
                    "original_output": to_hex(output1) if output1 else None,
                    "transpiled_output": to_hex(output2) if output2 else None,
                    "original_gas_used": gas1,
                    "transpiled_gas_used": gas2,
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
