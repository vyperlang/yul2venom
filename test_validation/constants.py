"""Constants for the test validation framework."""

from dataclasses import dataclass

# Display
SEPARATOR_WIDTH = 60
SEPARATOR = "=" * SEPARATOR_WIDTH

# Compilation
SOLC_OPTIMIZATION_RUNS = 200
YUL_OUTPUT_SUBDIR = "yul"

# Execution
DEFAULT_GAS_LIMIT = 1_000_000
DEFAULT_DEPLOYER_BALANCE = 10**18  # 1 ETH
STORAGE_SLOTS_TO_CHECK = 10

# Deployment gas limit (higher than default for complex deployments)
DEPLOYMENT_GAS_LIMIT = 5_000_000


@dataclass(frozen=True)
class Phase:
    """Compilation phase metadata for progress display."""
    step: int
    total: int
    description: str

    def __str__(self) -> str:
        return f"[{self.step}/{self.total}] {self.description}"


# Compilation phases (for progress display)
PHASE_SOLIDITY_TO_YUL = Phase(1, 5, "Compiling Solidity to Yul")
PHASE_SOLIDITY_TO_BYTECODE = Phase(2, 5, "Compiling Solidity to bytecode (reference)")
PHASE_YUL_TO_VENOM = Phase(3, 5, "Transpiling Yul to Venom IR")
PHASE_BYTECODE_GENERATION = Phase(4, 5, "Generating bytecode from Venom")
PHASE_EXECUTION_VALIDATION = Phase(5, 5, "Validating bytecode through execution")
