# DAO Maker - Command Reference

**Practical command guide for development, testing, and deployment**

> **Clone the repository first:**
> ```bash
> git clone https://github.com/mwihoti/daomaker.git
> cd daomaker
> ```

---

## 📋 Terminal Management

> **Note:** For development workflows, keep multiple terminals running:
> - **Terminal 1:** Sandbox (runs continuously) - `daml sandbox --port 6865 --json-api-port 7575`
> - **Terminal 2:** Build/Test commands (interactive)
> - **Terminal 3:** curl/JSON API testing (interactive)
>
> Run long-lived services with `&` or in separate terminals to avoid blocking.

---

## 🚀 Build Commands

### Build Core Package
```bash
daml build
```
**From:** Repository root (`daomaker/`)

### Build Scripts Package
```bash
cd scripts
daml build
```
**From:** Repository root, then navigate to scripts

### Clean Build (Remove artifacts first)
```bash
daml clean
daml build
```
**From:** Repository root

### Build Both Packages
```bash
daml build && cd scripts && daml build
```
**From:** Repository root

---

## 🧪 Test Commands

### Run Full Test Suite
```bash
cd scripts
daml test
```
**From:** Repository root, then navigate to scripts

### Run All Tests with Verbose Output
```bash
cd scripts
daml test --verbose
```
**From:** Repository root, then navigate to scripts

---

## 🎯 Run Individual Tests

### Test Liquidation
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name RiskManagement:testLiquidation
```
**From:** Repository root

### Test Confidential Settlement
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name RiskManagement:testConfidentialSettlement
```
**From:** Repository root

### Test Position Tracking
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name RiskManagement:testPositionTracking
```
**From:** Repository root

### Test Emergency Shutdown
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name RiskManagement:testEmergencyShutdown
```
**From:** Repository root

### Test Risk Management Integration
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name RiskManagement:testRiskManagementIntegration
```
**From:** Repository root

### Test Complete Workflow
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:testCompleteWorkflow
```
**From:** Repository root

---

## 🏃 Run Workflow Steps

### Setup DAO
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:setupDAO
```
**From:** Repository root

### Issue Tokens
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:issueTokens
```
**From:** Repository root

### Alice Stakes Tokens
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:aliceStakes
```
**From:** Repository root

### Bob Stakes Tokens
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:bobStakes
```
**From:** Repository root

### Create Proposal
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:createProposal
```
**From:** Repository root

### Alice Votes
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:aliceVotes
```
**From:** Repository root

### Bob Votes
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:bobVotes
```
**From:** Repository root

### Create Margin Account
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:createMarginAccount
```
**From:** Repository root

### Alice Deposits Collateral
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:aliceDepositsCollateral
```
**From:** Repository root

---

## 🌐 Sandbox & Ledger Commands

### Start Sandbox with JSON API
```bash
daml sandbox --port 6865 --json-api-port 7575
```
**Run in separate Terminal 1 - Keep running**  
**From:** Repository root

### Start Sandbox in Background
```bash
daml sandbox --port 6865 --json-api-port 7575 > /tmp/sandbox.log 2>&1 &
```
**Runs in background of current terminal**  
**From:** Repository root

### Start Sandbox with Full Logging
```bash
daml sandbox --port 6865 --json-api-port 7575 --loglevel DEBUG
```
**For debugging - Keep running in separate terminal**  
**From:** Repository root

### List Packages on Ledger
```bash
daml ledger list-packages --host localhost --port 6865
```
**From:** Any directory (if sandbox is running)

### Upload DAR File
```bash
daml ledger upload-dar .daml/dist/dao-maker-1.0.0.dar \
  --host localhost \
  --port 6865
```
**From:** Repository root

### Upload Scripts DAR
```bash
daml ledger upload-dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --host localhost \
  --port 6865
```
**From:** Repository root

---

## 🌍 JSON API Commands (curl)

> **Note:** Requires sandbox running with JSON API port 7575
> - Run in **Terminal 3** for interactive testing
> - Sandbox (Terminal 1) must remain running

### Get OpenAPI Specification
```bash
curl localhost:7575/docs/openapi > openapi.yaml
```
**From:** Terminal 3 or any directory

### Create Party (Alice)
```bash
curl -d '{"partyIdHint":"Alice","identityProviderId":""}' \
  -H "Content-Type: application/json" \
  -X POST localhost:7575/v2/parties
```
**From:** Terminal 3 or any directory

### Create Party (Bob)
```bash
curl -d '{"partyIdHint":"Bob","identityProviderId":""}' \
  -H "Content-Type: application/json" \
  -X POST localhost:7575/v2/parties
```
**From:** Terminal 3 or any directory

### List All Parties
```bash
curl localhost:7575/v2/parties
```
**From:** Terminal 3 or any directory

### Query Active Contracts (GovernanceToken)
```bash
curl -d '{"templateIds":["1b2d33b9f3abb62b29ac3ac81a024fbb38c20ecf8da7c3e4d5b8c6f5d3f8c9a0:GovernanceToken.Token"]}' \
  -H "Content-Type: application/json" \
  -X POST localhost:7575/v2/user_query
```
**From:** Terminal 3 or any directory

### Query Active Contracts (All)
```bash
curl localhost:7575/v2/user_query
```
**From:** Terminal 3 or any directory

### Submit Command via JSON API
```bash
curl -d '{
  "templateId": "1b2d33b9f3abb62b29ac3ac81a024fbb38c20ecf8da7c3e4d5b8c6f5d3f8c9a0:GovernanceToken.Token",
  "payload": {"issuer": "Alice", "owner": "Bob", "quantity": 100}
}' \
  -H "Content-Type: application/json" \
  -X POST localhost:7575/v2/create
```
**From:** Terminal 3 or any directory

### Get Package Metadata
```bash
curl localhost:7575/v2/packages
```
**From:** Terminal 3 or any directory

### Health Check
```bash
curl localhost:7575/health
```
**From:** Terminal 3 or any directory

---

## 📊 Daml Script Commands

### Run Script Against Remote Ledger
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:setupDAO \
  --ledger-host remote.host.com \
  --ledger-port 6865
```
**From:** Repository root

### Run Script with Ledger API Options
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name RiskManagement:testLiquidation \
  --ledger-host localhost \
  --ledger-port 6865 \
  --wall-clock-time
```
**From:** Repository root

### View Script Execution with Trace
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:setupDAO \
  --ledger-host localhost \
  --ledger-port 6865 2>&1 | tee script-output.log
```
**From:** Repository root

---

## 🔍 Inspection & Debugging

### Check Sandbox Port Status
```bash
netstat -tuln | grep 6865
```
**From:** Any directory

### Check JSON API Port
```bash
netstat -tuln | grep 7575
```
**From:** Any directory

### View Sandbox Logs
```bash
tail -50 /tmp/sandbox.log
```
**From:** Any directory

### Follow Sandbox Logs Live
```bash
tail -f /tmp/sandbox.log
```
**Keep running in Terminal 4 for live debugging**

### Check Process Status
```bash
ps aux | grep -E "daml|canton" | grep -v grep
```
**From:** Any directory

### Verify DAR Files Exist
```bash
ls -lh .daml/dist/*.dar
ls -lh scripts/.daml/dist/*.dar
```
**From:** Repository root

### Check File Sizes
```bash
du -h .daml/dist/
du -h scripts/.daml/dist/
```
**From:** Repository root

---

## 🛑 Stop & Cleanup

### Stop Sandbox (Kill Process)
```bash
pkill -f "daml sandbox"
```
**Stops Terminal 1 sandbox process**

### Force Kill All Daml/Canton Processes
```bash
pkill -9 -f "canton|daml"
```
**Emergency cleanup - kills all Daml processes**

### Clean Build Artifacts
```bash
daml clean
```
**From:** Repository root

### Clean All (Core + Scripts)
```bash
daml clean
cd scripts && daml clean
```
**From:** Repository root

### Remove DAR Files
```bash
rm -f .daml/dist/*.dar
rm -f scripts/.daml/dist/*.dar
```
**From:** Repository root

---

## ⚡ One-Line Quick Commands

### Build & Test Core Only
```bash
daml clean && daml build && cd scripts && daml test
```
**From:** Repository root

### Build Both & Run Liquidation Test
```bash
daml build && cd scripts && daml build && daml script --dar .daml/dist/dao-maker-scripts-1.0.0.dar --script-name RiskManagement:testLiquidation
```
**From:** Repository root

### Fresh Sandbox with DAO Setup
```bash
pkill -f "daml sandbox" || true && sleep 1 && daml sandbox --port 6865 --json-api-port 7575 > /tmp/sandbox.log 2>&1 & sleep 5 && daml ledger upload-dar .daml/dist/dao-maker-1.0.0.dar --host localhost --port 6865 && daml ledger upload-dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar --host localhost --port 6865
```
**From:** Repository root (starts sandbox in background in Terminal 1)

### Quick Test All Features
```bash
cd scripts && daml test 2>&1 | grep -E "ok,|failed"
```
**From:** Repository root

### Setup & Run Workflow
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar --script-name WorkingInteractive:setupDAO && daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar --script-name WorkingInteractive:testCompleteWorkflow
```
**From:** Repository root

---

## 📋 Common Workflows

### Full Development Cycle
**Terminal 1:** (Keep running)
```bash
daml sandbox --port 6865 --json-api-port 7575
```

**Terminal 2:**
```bash
# 1. Build
daml build

# 2. Build scripts
cd scripts
daml build

# 3. Run tests
daml test
```
**From:** Repository root

---

### Deploy to Fresh Sandbox

**Terminal 1:** (Keep running)
```bash
# 1. Kill existing sandbox
pkill -f "daml sandbox" || true

# 2. Start new sandbox
daml sandbox --port 6865 --json-api-port 7575 > /tmp/sandbox.log 2>&1 &
```

**Terminal 2:**
```bash
# Wait for sandbox to start
sleep 5

# 3. Upload DARs
daml ledger upload-dar .daml/dist/dao-maker-1.0.0.dar --host localhost --port 6865
daml ledger upload-dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar --host localhost --port 6865

# 4. Initialize DAO
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:setupDAO \
  --ledger-host localhost \
  --ledger-port 6865
```
**From:** Repository root

---

### Test Individual Features in Sequence

**Terminal 1:** (Keep running)
```bash
daml sandbox --port 6865 --json-api-port 7575
```

**Terminal 2:**
```bash
# Liquidation
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar --script-name RiskManagement:testLiquidation

# Confidential Settlement
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar --script-name RiskManagement:testConfidentialSettlement

# Position Tracking
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar --script-name RiskManagement:testPositionTracking

# Emergency Shutdown
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar --script-name RiskManagement:testEmergencyShutdown

# Full Integration
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar --script-name RiskManagement:testRiskManagementIntegration
```
**From:** Repository root

---

### JSON API Testing

**Terminal 1:** (Keep running)
```bash
daml sandbox --port 6865 --json-api-port 7575
```

**Terminal 3:** (For curl commands)
```bash
# Create parties
curl -d '{"partyIdHint":"TestParty","identityProviderId":""}' \
  -H "Content-Type: application/json" \
  -X POST localhost:7575/v2/parties

# List parties
curl localhost:7575/v2/parties

# Get API spec
curl localhost:7575/docs/openapi > api-spec.yaml

# Check health
curl localhost:7575/health
```
**From:** Any directory

---

## 🔗 Configuration

### Sandbox Default Settings
- **Port:** 6865
- **JSON API Port:** 7575
- **Host:** localhost
- **Protocol:** gRPC

### Example Remote Ledger
- **Host:** canton.example.com
- **Port:** 6865
- **Protocol:** gRPC

### Modify Sandbox Port
```bash
daml sandbox --port 7000 --json-api-port 7575
```

### Modify JSON API Port
```bash
daml sandbox --port 6865 --json-api-port 8080
```

---

## 📁 Project Structure

```
daomaker/                          # Git repository root
├── daml/                           # Core Daml packages
│   ├── GovernanceToken.daml
│   ├── Staking.daml
│   ├── Governance.daml
│   ├── DAOSetup.daml
│   ├── Margin.daml                # Contains risk management features
│   └── ...
├── scripts/                        # Test scripts
│   ├── daml/
│   │   ├── Test.daml
│   │   ├── SimpleTest.daml
│   │   ├── WorkingInteractive.daml
│   │   ├── RiskManagement.daml    # New risk management tests
│   │   └── ...
│   └── daml.yaml
├── .daml/
│   └── dist/
│       └── dao-maker-1.0.0.dar     # Core package artifact
├── daml.yaml                       # Core configuration
├── COMMANDS.md                     # This file
└── deploy.sh, deploy-init-dao.sh   # Deployment scripts
```

---

## 📝 Environment Variables (Optional)

```bash
# Set custom ledger host
export DAML_LEDGER_HOST=localhost

# Set custom ledger port
export DAML_LEDGER_PORT=6865

# Set custom JSON API port
export DAML_JSON_API_PORT=7575
```

---

## 🚨 Troubleshooting

### Port Already in Use
```bash
# Check what's using port 6865
lsof -i :6865

# Find and kill process
pkill -f "daml sandbox"
```

### Sandbox Won't Start
```bash
# Check logs
tail -50 /tmp/sandbox.log

# Kill any lingering processes
pkill -9 -f "canton"
```

### Build Failures
```bash
# Clean and rebuild
daml clean
daml build

# Check for errors
daml build 2>&1 | grep -i error
```
**From:** Repository root

### Test Failures
```bash
# Run tests with verbose output
cd scripts
daml test --verbose

# Check recent test output
daml test 2>&1 | tail -100
```

### DAR Upload Failed
```bash
# Verify DAR exists
ls -lh .daml/dist/*.dar

# Check sandbox is running
netstat -tuln | grep 6865

# Try upload with verbose
daml ledger upload-dar .daml/dist/dao-maker-1.0.0.dar \
  --host localhost \
  --port 6865 \
  --verbose
```

### JSON API Not Responding
```bash
# Check port
netstat -tuln | grep 7575

# Restart sandbox with JSON API
pkill -f "daml sandbox"
daml sandbox --port 6865 --json-api-port 7575
```

---

## ✅ Verification Checklist

**Terminal 1:** (Keep running)
```bash
daml sandbox --port 6865 &
sleep 3
```

**Terminal 2:**
```bash
# 1. Verify build succeeds
daml build

# 2. Verify tests pass
cd scripts && daml test

# 3. Verify sandbox starts
curl localhost:7575/health

# 4. Verify DARs can be uploaded
daml ledger upload-dar .daml/dist/dao-maker-1.0.0.dar \
  --host localhost --port 6865

# 5. Verify script runs
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:setupDAO
```
**From:** Repository root

---

## 📚 Additional Resources

- **Daml Docs:** https://docs.daml.com
- **JSON API:** https://docs.daml.com/json-api
- **Ledger API:** https://docs.daml.com/app-dev/ledger-api.html
- **Daml Script:** https://docs.daml.com/daml-script

---

**Last Updated:** December 7, 2025  
**Version:** 2.0.0  
**Format:** Practical command reference for developers
