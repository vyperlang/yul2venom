#!/bin/bash

# Yul-to-Venom Test Runner Script

echo "========================================"
echo "Yul-to-Venom Validation System Test"
echo "========================================"

# Use the project's virtual environment
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/.venv/bin/python" ]]; then
    PYTHON="$SCRIPT_DIR/.venv/bin/python"
else
    PYTHON=python3.12
fi

# Check if solc is installed
if ! command -v solc &> /dev/null; then
    echo "Error: solc is not installed"
    echo "Please install solc: brew install solidity"
    exit 1
fi

echo "[OK] solc found: $(solc --version | head -1)"

# Check Python version
echo "[OK] Python: $($PYTHON --version)"

# Install dependencies if needed
echo ""
echo "Installing dependencies..."
$PYTHON -m pip install -q -r requirements.txt

# Resolve repository paths
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_VYPER_REPO="$(cd "$REPO_ROOT" && realpath ../vyper 2>/dev/null || true)"

if [[ -n "$DEFAULT_VYPER_REPO" && -d "$DEFAULT_VYPER_REPO" ]]; then
    VYPER_REPO="${VYPER_REPO:-$DEFAULT_VYPER_REPO}"
fi

if [[ -z "$VYPER_REPO" || ! -d "$VYPER_REPO" ]]; then
    echo "Warning: VYPER_REPO not set and ../vyper not found. Ensure Vyper is on PYTHONPATH."
    VYPER_REPO=""
fi

# Run the test orchestrator
echo ""
echo "Running validation tests..."
echo "========================================"
if [[ -n "$VYPER_REPO" ]]; then
    PYTHONPATH="$REPO_ROOT:$VYPER_REPO:${PYTHONPATH}" $PYTHON -m test_validation.test_orchestrator "$@"
else
    PYTHONPATH="$REPO_ROOT:${PYTHONPATH}" $PYTHON -m test_validation.test_orchestrator "$@"
fi
