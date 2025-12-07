#!/bin/bash
# Deployment script for DAO Maker
# Supports local sandbox and remote Canton network deployment

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"
DAR_FILE="$PROJECT_ROOT/.daml/dist/dao-maker-1.0.0.dar"
SCRIPTS_DAR="$PROJECT_ROOT/scripts/.daml/dist/dao-maker-scripts-1.0.0.dar"

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Deployment mode
DEPLOYMENT_MODE="${1:-sandbox}"
LEDGER_HOST="${2:-localhost}"
LEDGER_PORT="${3:-6865}"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}DAO Maker Deployment Script${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "Deployment Mode: ${GREEN}$DEPLOYMENT_MODE${NC}"
echo -e "Ledger Host: ${GREEN}$LEDGER_HOST${NC}"
echo -e "Ledger Port: ${GREEN}$LEDGER_PORT${NC}"
echo -e "DAR File: ${GREEN}$DAR_FILE${NC}"
echo ""

# Verify DAR files exist
if [ ! -f "$DAR_FILE" ]; then
    echo -e "${RED}ERROR: DAR file not found at $DAR_FILE${NC}"
    echo "Please run 'daml build' first"
    exit 1
fi

if [ ! -f "$SCRIPTS_DAR" ]; then
    echo -e "${RED}ERROR: Scripts DAR file not found at $SCRIPTS_DAR${NC}"
    echo "Please run 'cd scripts && daml build' first"
    exit 1
fi

echo -e "${GREEN}✓ DAR files verified${NC}"
echo ""

# Function to check if ledger is running
check_ledger() {
    if nc -z $LEDGER_HOST $LEDGER_PORT 2>/dev/null; then
        echo -e "${GREEN}✓ Ledger is running on $LEDGER_HOST:$LEDGER_PORT${NC}"
        return 0
    else
        echo -e "${RED}✗ Ledger is NOT running on $LEDGER_HOST:$LEDGER_PORT${NC}"
        return 1
    fi
}

# Deploy to sandbox
deploy_sandbox() {
    echo -e "${BLUE}Starting deployment to Sandbox...${NC}"
    echo ""
    
    if ! check_ledger; then
        echo -e "${BLUE}Starting Daml Sandbox...${NC}"
        daml sandbox --port $LEDGER_PORT &
        SANDBOX_PID=$!
        sleep 3
        echo -e "${GREEN}✓ Sandbox started (PID: $SANDBOX_PID)${NC}"
    fi
    
    echo ""
    echo -e "${BLUE}Uploading DAR files...${NC}"
    daml ledger upload-dar "$DAR_FILE" \
        --host $LEDGER_HOST \
        --port $LEDGER_PORT
    
    daml ledger upload-dar "$SCRIPTS_DAR" \
        --host $LEDGER_HOST \
        --port $LEDGER_PORT
    
    echo -e "${GREEN}✓ DAR files uploaded successfully${NC}"
    echo ""
    
    echo -e "${BLUE}Deployment Summary:${NC}"
    echo -e "  Host: $LEDGER_HOST"
    echo -e "  Port: $LEDGER_PORT"
    echo -e "  DAR: dao-maker-1.0.0.dar"
    echo -e "  Scripts DAR: dao-maker-scripts-1.0.0.dar"
    echo ""
    
    if [ -n "$SANDBOX_PID" ]; then
        echo -e "${BLUE}Sandbox is running in background (PID: $SANDBOX_PID)${NC}"
        echo -e "${BLUE}To stop it, run: kill $SANDBOX_PID${NC}"
    fi
}

# Deploy to remote Canton network
deploy_remote() {
    echo -e "${BLUE}Deploying to remote Canton network...${NC}"
    echo ""
    
    if ! check_ledger; then
        echo -e "${RED}ERROR: Cannot connect to ledger at $LEDGER_HOST:$LEDGER_PORT${NC}"
        echo "Please ensure the Canton network is running and accessible"
        exit 1
    fi
    
    echo ""
    echo -e "${BLUE}Uploading DAR files...${NC}"
    daml ledger upload-dar "$DAR_FILE" \
        --host $LEDGER_HOST \
        --port $LEDGER_PORT
    
    daml ledger upload-dar "$SCRIPTS_DAR" \
        --host $LEDGER_HOST \
        --port $LEDGER_PORT
    
    echo -e "${GREEN}✓ DAR files uploaded successfully${NC}"
    echo ""
    
    echo -e "${BLUE}Deployment Summary:${NC}"
    echo -e "  Host: $LEDGER_HOST"
    echo -e "  Port: $LEDGER_PORT"
    echo -e "  Network: Remote Canton"
    echo -e "  DAR: dao-maker-1.0.0.dar"
    echo -e "  Scripts DAR: dao-maker-scripts-1.0.0.dar"
}

# Main deployment logic
case $DEPLOYMENT_MODE in
    sandbox)
        deploy_sandbox
        ;;
    remote)
        deploy_remote
        ;;
    *)
        echo -e "${RED}ERROR: Unknown deployment mode '$DEPLOYMENT_MODE'${NC}"
        echo "Usage: $0 [sandbox|remote] [host] [port]"
        echo "Example: $0 sandbox localhost 6865"
        echo "Example: $0 remote my-canton.network 6865"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}✓ Deployment complete!${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "1. Run initialization script: ./deploy-init-dao.sh"
echo "2. Use Daml Navigator or scripts to interact with the DAO"
echo "3. Check logs: daml script --dar $SCRIPTS_DAR --script-name WorkingInteractive:setupDAO"
