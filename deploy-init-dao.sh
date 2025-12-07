#!/bin/bash
# Initialize DAO on deployed ledger

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
SCRIPT_NAME="${3:-WorkingInteractive:setupDAO}"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}DAO Initialization Script${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "Ledger Host: ${GREEN}$LEDGER_HOST${NC}"
echo -e "Ledger Port: ${GREEN}$LEDGER_PORT${NC}"
echo -e "Script: ${GREEN}$SCRIPT_NAME${NC}"
echo ""

if [ ! -f "$SCRIPTS_DAR" ]; then
    echo -e "${RED}ERROR: Scripts DAR not found at $SCRIPTS_DAR${NC}"
    exit 1
fi

echo -e "${BLUE}Running initialization...${NC}"
echo ""

daml script \
    --dar "$SCRIPTS_DAR" \
    --script-name "$SCRIPT_NAME" \
    --ledger-host "$LEDGER_HOST" \
    --ledger-port "$LEDGER_PORT"

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✓ DAO initialized successfully!${NC}"
else
    echo ""
    echo -e "${RED}✗ DAO initialization failed${NC}"
    exit 1
fi
