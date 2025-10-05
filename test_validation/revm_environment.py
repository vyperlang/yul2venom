#!/usr/bin/env python3
"""
Simplified EVM execution environment using pyrevm for testing.
"""

from typing import Dict, List, Optional, Tuple, Any
from dataclasses import dataclass
from pyrevm import EVM
from eth_utils import to_checksum_address, to_hex, to_bytes, keccak, function_signature_to_4byte_selector
import json


@dataclass
class Account:
    """Represents an EVM account."""
    address: str
    balance: int = 10**18  # Default 1 ETH
    nonce: int = 0
    code: Optional[bytes] = None


@dataclass 
class Transaction:
    """Represents an EVM transaction."""
    from_addr: str
    to_addr: Optional[str]
    data: bytes
    value: int = 0
    gas_limit: int = 1_000_000


@dataclass
class ExecutionResult:
    """Result of executing a transaction."""
    success: bool
    output: bytes
    gas_used: int
    storage_changes: Dict[int, int]
    logs: List[Any]


class RevmEnvironment:
    """
    Simplified wrapper around pyrevm for testing contract execution.
    """
    
    def __init__(self):
        """Initialize a new EVM environment."""
        self.evm = EVM()
        self.accounts: Dict[str, Account] = {}
        self.contracts: Dict[str, str] = {}  # address -> name mapping
        
        # Set up default blockchain environment
        self.reset_blockchain()
        
        # Create some default test accounts
        self.create_test_accounts()
    
    def reset_blockchain(self):
        """Reset blockchain to initial state."""
        self.evm = EVM()
        # pyrevm has default block environment, we can use it as is
    
    def create_test_accounts(self):
        """Create default test accounts with balance."""
        test_accounts = [
            ("deployer", "0x1000000000000000000000000000000000000001"),
            ("alice", "0x2000000000000000000000000000000000000002"),
            ("bob", "0x3000000000000000000000000000000000000003"),
        ]
        
        for name, address in test_accounts:
            self.accounts[name] = Account(address=address)
            self.evm.set_balance(address, 10**18)  # 1 ETH each
    
    def deploy_contract(self, 
                       bytecode: str, 
                       name: str = "Contract",
                       deployer: str = "deployer",
                       constructor_args: bytes = b"") -> Tuple[bool, Optional[str]]:
        """
        Deploy a contract from bytecode.
        
        Args:
            bytecode: Hex string of deployment bytecode
            name: Name for the contract (for tracking)
            deployer: Name or address of deployer account
            constructor_args: Constructor arguments as bytes
        
        Returns:
            Tuple of (success, contract_address)
        """
        # Get deployer address
        if deployer in self.accounts:
            deployer_addr = self.accounts[deployer].address
        else:
            deployer_addr = deployer
        
        # Remove 0x prefix if present
        if bytecode.startswith("0x"):
            bytecode = bytecode[2:]
        
        # Combine bytecode with constructor args
        full_bytecode = bytes.fromhex(bytecode) + constructor_args
        
        # Deploy the contract
        try:
            contract_address = self.evm.deploy(
                deployer=deployer_addr,
                code=full_bytecode,
                value=0,
                gas=5_000_000
            )
            
            if contract_address:
                contract_address = to_checksum_address(contract_address)
                self.contracts[contract_address] = name
                return True, contract_address
            else:
                return False, None
        except Exception:
            return False, None
    
    def call_function(self,
                     contract_address: str,
                     function_sig: str,
                     args: List[Any] = None,
                     caller: str = "alice",
                     value: int = 0) -> ExecutionResult:
        """
        Call a contract function.
        
        Args:
            contract_address: Address of the contract
            function_sig: Function signature like "transfer(address,uint256)"
            args: Function arguments
            caller: Name or address of caller
            value: Wei to send
        
        Returns:
            ExecutionResult
        """
        # Get caller address
        if caller in self.accounts:
            caller_addr = self.accounts[caller].address
        else:
            caller_addr = caller
        
        # Create calldata
        if function_sig:
            selector = function_signature_to_4byte_selector(function_sig)
            calldata = selector
            
            # Encode arguments (simplified - proper ABI encoding needed for production)
            if args:
                for arg in args:
                    if isinstance(arg, int):
                        calldata += arg.to_bytes(32, byteorder='big')
                    elif isinstance(arg, str) and len(arg) == 42:  # Address
                        addr_bytes = bytes.fromhex(arg[2:] if arg.startswith("0x") else arg)
                        calldata += b'\x00' * 12 + addr_bytes
                    elif isinstance(arg, bytes):
                        calldata += arg
        else:
            calldata = b""
        
        # Get storage before call
        storage_before = {}
        for i in range(20):  # Check first 20 slots
            storage_val = self.evm.storage(contract_address, i)
            storage_before[i] = storage_val if storage_val is not None else 0
        
        # Execute the call
        try:
            output = self.evm.message_call(
                caller=caller_addr,
                to=contract_address,
                calldata=calldata,
                value=value,
                gas=1_000_000,
                is_static=False
            )
            success = True
        except Exception:
            output = b""
            success = False
        
        # Get storage changes
        storage_changes = {}
        for i in range(20):
            storage_val = self.evm.storage(contract_address, i)
            after = storage_val if storage_val is not None else 0
            if storage_before[i] != after:
                storage_changes[i] = after
        
        return ExecutionResult(
            success=success,
            output=output if output else b"",
            gas_used=0,  # pyrevm doesn't expose gas used easily
            storage_changes=storage_changes,
            logs=[]  # TODO: Extract logs if needed
        )
    
    def get_storage_at(self, contract_address: str, slot: int) -> int:
        """Get storage value at a specific slot."""
        val = self.evm.storage(contract_address, slot)
        return val if val is not None else 0
    
    def set_storage_at(self, contract_address: str, slot: int, value: int):
        """Set storage value at a specific slot."""
        # pyrevm doesn't have a direct set_storage method
        # Storage is managed through transactions
    
    def get_balance(self, address: str) -> int:
        """Get balance of an address."""
        return self.evm.get_balance(address)
    
    def set_balance(self, address: str, balance: int):
        """Set balance of an address."""
        self.evm.set_balance(address, balance)
    
    def compare_contracts(self,
                         bytecode1: str,
                         bytecode2: str,
                         test_scenarios: List[Dict[str, Any]]) -> Dict[str, Any]:
        """
        Deploy two contracts and compare their behavior across test scenarios.
        
        Args:
            bytecode1: First contract bytecode
            bytecode2: Second contract bytecode
            test_scenarios: List of test scenarios to execute
        
        Returns:
            Comparison results
        """
        results = {
            "deployment": {},
            "scenarios": [],
            "overall_match": True
        }
        
        # Deploy first contract
        self.reset_blockchain()
        self.create_test_accounts()
        success1, addr1 = self.deploy_contract(bytecode1, "Contract1")
        results["deployment"]["contract1"] = {"success": success1, "address": addr1}
        
        # Deploy second contract
        self.reset_blockchain()
        self.create_test_accounts()
        success2, addr2 = self.deploy_contract(bytecode2, "Contract2")
        results["deployment"]["contract2"] = {"success": success2, "address": addr2}
        
        if not (success1 and success2):
            results["overall_match"] = False
            return results
        
        # Run test scenarios
        for scenario in test_scenarios:
            scenario_result = {
                "name": scenario.get("name", "unnamed"),
                "match": True,
                "details": {}
            }
            
            # Reset and run on contract 1
            self.reset_blockchain()
            self.create_test_accounts()
            self.deploy_contract(bytecode1, "Contract1")
            result1 = self.call_function(
                addr1,
                scenario.get("function"),
                scenario.get("args", []),
                scenario.get("caller", "alice"),
                scenario.get("value", 0)
            )
            
            # Reset and run on contract 2
            self.reset_blockchain()
            self.create_test_accounts()
            self.deploy_contract(bytecode2, "Contract2")
            result2 = self.call_function(
                addr2,
                scenario.get("function"),
                scenario.get("args", []),
                scenario.get("caller", "alice"),
                scenario.get("value", 0)
            )
            
            # Compare results
            if result1.success != result2.success:
                scenario_result["match"] = False
                scenario_result["details"]["success_mismatch"] = {
                    "contract1": result1.success,
                    "contract2": result2.success
                }
            
            if result1.output != result2.output:
                scenario_result["match"] = False
                scenario_result["details"]["output_mismatch"] = {
                    "contract1": to_hex(result1.output) if result1.output else None,
                    "contract2": to_hex(result2.output) if result2.output else None
                }
            
            if result1.storage_changes != result2.storage_changes:
                scenario_result["match"] = False
                scenario_result["details"]["storage_mismatch"] = {
                    "contract1": result1.storage_changes,
                    "contract2": result2.storage_changes
                }
            
            if not scenario_result["match"]:
                results["overall_match"] = False
            
            results["scenarios"].append(scenario_result)
        
        return results


def create_test_scenario(name: str,
                        function: str,
                        args: List[Any] = None,
                        caller: str = "alice",
                        value: int = 0,
                        expected_success: bool = True) -> Dict[str, Any]:
    """
    Helper to create a test scenario.
    
    Args:
        name: Name of the test
        function: Function signature
        args: Function arguments
        caller: Caller account name
        value: Wei to send
        expected_success: Whether call should succeed
    
    Returns:
        Test scenario dict
    """
    return {
        "name": name,
        "function": function,
        "args": args or [],
        "caller": caller,
        "value": value,
        "expected_success": expected_success
    }