#!/bin/bash
# Run tests on deployed ledger

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"
SCRIPTS_DAR="$PROJECT_ROOT/scripts/.daml/dist/dao-maker-scripts-1.0.0.dar"

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

LEDGER_HOST="${1:-localhost}"
LEDGER_PORT="${2:-6865}"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}DAO Test Suite${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Available test scripts
declare -a TESTS=(
    "WorkingInteractive:setupDAO"
    "WorkingInteractive:testCompleteWorkflow"
    "RiskManagement:testLiquidation"
    "RiskManagement:testConfidentialSettlement"
    "RiskManagement:testPositionTracking"
    "RiskManagement:testEmergencyShutdown"
    "RiskManagement:testRiskManagementIntegration"
)

if [ "$#" -eq 0 ] || [ "$1" == "--help" ]; then
    echo "Usage: $0 [test_name] [host] [port]"
    echo ""
    echo "Available tests:"
    for test in "${TESTS[@]}"; do
        echo "  - $test"
    done
    echo ""
    echo "Examples:"
    echo "  $0                                    # Run all tests"
    echo "  $0 WorkingInteractive:setupDAO        # Run specific test"
    echo "  $0 RiskManagement:testLiquidation 192.168.1.100 6865"
    exit 0
fi

TEST_FILTER="${1:-*}"
LEDGER_HOST="${2:-localhost}"
LEDGER_PORT="${3:-6865}"

echo -e "Running tests matching: ${GREEN}$TEST_FILTER${NC}"
echo -e "Ledger: ${GREEN}$LEDGER_HOST:$LEDGER_PORT${NC}"
echo ""

if [ ! -f "$SCRIPTS_DAR" ]; then
    echo -e "${RED}ERROR: Scripts DAR not found${NC}"
    exit 1
fi

# Run tests
cd "$PROJECT_ROOT/scripts"
daml test

echo ""
echo -e "${GREEN}✓ Test suite complete!${NC}"
