# SolVenom

Solidity to EVM bytecode compiler via Venom IR. Compiles Solidity source code through an alternative compilation pipeline: Solidity → Yul → Venom IR → EVM bytecode.

## Requirements

- Python 3.11+
- [solc](https://docs.soliditylang.org/en/latest/installing-solidity.html) (Solidity compiler)
- [Vyper repository](https://github.com/vyperlang/vyper) (for Venom IR infrastructure)

## Installation

```bash
# Clone the repository
git clone https://github.com/yourorg/yul-to-venom.git
cd yul-to-venom

# Clone Vyper (required for Venom IR)
git clone https://github.com/vyperlang/vyper.git ../vyper

# Create virtual environment
python -m venv .venv
source .venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Install Vyper dependencies
pip install -r ../vyper/requirements.txt
```

## Quick Start

```bash
source .venv/bin/activate

# Compile a Solidity file to bytecode
PYTHONPATH=../vyper:. python -m yul_to_venom.cli.solvenom MyContract.sol

# Output Venom IR instead of bytecode
PYTHONPATH=../vyper:. python -m yul_to_venom.cli.solvenom MyContract.sol --venom

# Output assembly
PYTHONPATH=../vyper:. python -m yul_to_venom.cli.solvenom MyContract.sol --asm
```

## Usage

```
python -m yul_to_venom.cli.solvenom <solidity_file> [options]
```

### Output Formats

| Flag | Output |
|------|--------|
| (default) | Bytecode as hex string |
| `--venom` | Venom IR |
| `--asm` | EVM assembly |
| `--json` | JSON with bytecode, ABI, IR, and assembly |
| `--abi` | ABI only (JSON array) |

### Contract Selection

| Flag | Description |
|------|-------------|
| `--contract NAME` | Compile specific contract by name |
| `--all` | Compile all contracts in the file |

### Import Resolution

| Flag | Description |
|------|-------------|
| `--base-path PATH` | Root directory for import resolution |
| `-I PATH` | Additional include directory (can repeat) |
| `-r MAPPING` | Import remapping, e.g. `@openzeppelin/=lib/openzeppelin/` |

Remappings are auto-loaded from `remappings.txt` if present in the base path or input file directory.

### Other Options

| Flag | Description |
|------|-------------|
| `-o FILE` | Write output to file instead of stdout |
| `-l NAME=ADDR` | Link library at address (can repeat) |
| `--no-optimize` | Disable optimization |
| `--evm-version VER` | Target EVM version (default: cancun) |
| `--solc PATH` | Path to solc binary |
| `--vyper-path PATH` | Path to Vyper repository |
| `-v` | Verbose output |

## Examples

### Basic Compilation

```bash
# Compile and output bytecode
python -m yul_to_venom.cli.solvenom contracts/Token.sol

# Compile specific contract from multi-contract file
python -m yul_to_venom.cli.solvenom contracts/Token.sol --contract ERC20

# Save bytecode to file
python -m yul_to_venom.cli.solvenom contracts/Token.sol -o Token.bin
```

### With OpenZeppelin Imports

```bash
# Using base-path for node_modules resolution
python -m yul_to_venom.cli.solvenom src/MyToken.sol --base-path .

# Using explicit remapping
python -m yul_to_venom.cli.solvenom src/MyToken.sol \
  -r "@openzeppelin/=node_modules/@openzeppelin/"
```

### Using remappings.txt

Create a `remappings.txt` file:
```
@openzeppelin/=node_modules/@openzeppelin/
@chainlink/=node_modules/@chainlink/
```

Then compile (remappings are auto-detected):
```bash
python -m yul_to_venom.cli.solvenom src/MyToken.sol --base-path .
```

### Library Linking

```bash
python -m yul_to_venom.cli.solvenom contracts/MyContract.sol \
  -l SafeMath=0x1234567890abcdef1234567890abcdef12345678
```

### JSON Output

```bash
# Get full compilation output as JSON
python -m yul_to_venom.cli.solvenom contracts/Token.sol --json

# Compile all contracts to JSON
python -m yul_to_venom.cli.solvenom contracts/Token.sol --all --json
```

JSON output includes:
```json
{
  "contractName": "Token",
  "fullyQualifiedName": "contracts/Token.sol:Token",
  "bytecode": "0x608060...",
  "abi": [...],
  "venomIR": "...",
  "assembly": "..."
}
```

## How It Works

SolVenom uses an alternative compilation pipeline:

1. **Solidity → Yul**: Uses `solc` to compile Solidity to Yul IR
2. **Yul → Venom IR**: Translates Yul AST to Vyper's Venom IR
3. **Venom IR → Bytecode**: Uses Vyper's backend for optimization and code generation

This approach leverages Vyper's Venom IR optimizer, which can produce different (sometimes smaller) bytecode compared to solc's native output.

## Testing

```bash
# Run all tests
python -m pytest

# Run SolVenom CLI tests
python -m pytest test_solvenom.py -v
```

## Supported EVM Versions

- `cancun` (default)
- `shanghai`
- `paris`
- `london`
- And other versions supported by both solc and Vyper

## License

See LICENSE file for details.
