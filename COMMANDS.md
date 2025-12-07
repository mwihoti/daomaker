# DAO Maker - Complete Command Reference

## 📦 DAR File Locations

| File | Size | Purpose | Location |
|------|------|---------|----------|
| **dao-maker-1.0.0.dar** | 470 KB | Core DAO templates (production) | `.daml/dist/` |
| **dao-maker-scripts-1.0.0.dar** | 614 KB | Test scripts & workflows | `scripts/.daml/dist/` |

⚠️ **Important**: Always use `scripts/.daml/dist/dao-maker-scripts-1.0.0.dar` (not the core DAR) when running `daml script` commands.

---

## 🔨 Build Commands

### Build Core DAO Templates
```bash
daml build
```

### Build Test Scripts
```bash
cd scripts
daml build
cd ..
```

### Build Both (Sequential)
```bash
daml build && cd scripts && daml build && cd ..
```

---

## 🚀 Sandbox & Deployment Commands

### Start Fresh Sandbox (Kill & Restart)
```bash
pkill -f "daml sandbox" || true
sleep 3
daml sandbox --port 6865 --json-api-port 7575
```

### Start Sandbox in Background
```bash
daml sandbox --port 6865 --json-api-port 7575 &
```

### Upload Core DAO DAR
```bash
daml ledger upload-dar .daml/dist/dao-maker-1.0.0.dar \
  --host localhost --port 6865 2>&1 | tail -5
```

### Upload Scripts DAR
```bash
daml ledger upload-dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --host localhost --port 6865 2>&1 | tail -5
```

### Upload Both DARs
```bash
daml ledger upload-dar .daml/dist/dao-maker-1.0.0.dar --host localhost --port 6865 && \
daml ledger upload-dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar --host localhost --port 6865
```

---

## ⚡ One-Command Full Workflow

### Build, Deploy & Run Complete Test
```bash
daml build && \
cd scripts && daml build && cd .. && \
pkill -f "daml sandbox" || true && sleep 3 && \
daml sandbox --port 6865 --json-api-port 7575 &
sleep 10 && \
daml ledger upload-dar .daml/dist/dao-maker-1.0.0.dar --host localhost --port 6865 && \
daml ledger upload-dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar --host localhost --port 6865 && \
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:testCompleteWorkflow \
  --ledger-host localhost --ledger-port 6865 2>&1 | tail -80
```

---

## 🧪 Complete Workflow Tests

### Run Full Workflow (Complete Output - 80 Lines)
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:testCompleteWorkflow \
  --ledger-host localhost --ledger-port 6865 2>&1 | tail -80
```

### Run Full Workflow (Filtered Output - Key Messages Only)
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:testCompleteWorkflow \
  --ledger-host localhost --ledger-port 6865 2>&1 | \
  grep -E "(✅|Already|voted|Complete workflow|Borrow successful|Collateral|Margin)" | head -30
```

---

## 📋 Individual Workflow Scripts

### Setup Phase

#### Create DAO (Admin, Staking Pool, Treasury)
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:setupDAO \
  --ledger-host localhost --ledger-port 6865
```

#### Issue Tokens (Alice: 1000, Bob: 800)
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:issueTokens \
  --ledger-host localhost --ledger-port 6865
```

### Staking Phase

#### Alice Stakes Tokens (500)
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:aliceStakes \
  --ledger-host localhost --ledger-port 6865
```

#### Bob Stakes Tokens (400)
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:bobStakes \
  --ledger-host localhost --ledger-port 6865
```

### Governance Phase

#### Create Proposal (PROP-001: Fund Community Event)
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:createProposal \
  --ledger-host localhost --ledger-port 6865
```

#### Alice Votes FOR (Idempotent - Checks if Already Voted)
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:aliceVotes \
  --ledger-host localhost --ledger-port 6865
```

#### Bob Votes FOR (Idempotent - Checks if Already Voted)
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:bobVotes \
  --ledger-host localhost --ledger-port 6865
```

### Margin Protocol Phase

#### Create Margin Account for Alice
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:createMarginAccount \
  --ledger-host localhost --ledger-port 6865
```

#### Alice Deposits 500 PDAO as Collateral
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:aliceDepositsCollateral \
  --ledger-host localhost --ledger-port 6865
```

#### Alice Borrows 200 PDAO (Maintains 2.5 Margin Ratio)
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:aliceBorrows \
  --ledger-host localhost --ledger-port 6865
```

### Status & Query Scripts

#### View Complete DAO Status
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:viewStatus \
  --ledger-host localhost --ledger-port 6865
```

#### View Margin Account Status (Collateral, Borrowed, Ratio)
```bash
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:viewMarginStatus \
  --ledger-host localhost --ledger-port 6865
```

---

## 🔄 Test Suite Commands

### Run All Tests
```bash
daml test
```

### Run Tests with Pattern Match
```bash
daml test --test-pattern testCompleteWorkflow
daml test --test-pattern testDepositTransaction
daml test --test-pattern runSimpleTests
```

### Run Tests Verbose
```bash
daml test --verbose
```

---

## 🔧 Maintenance & Debugging Commands

### Check Sandbox Status
```bash
# Is sandbox running on port 6865?
lsof -i :6865
```

### Check JSON API Status
```bash
# Verify JSON API is responding
curl http://localhost:7575/v1/packages
```

### View Sandbox Logs
```bash
tail -f /tmp/sandbox.log
```

### List Uploaded DARs
```bash
daml ledger list-dar --host localhost --port 6865
```

### Verify DAR Files Exist
```bash
ls -lh .daml/dist/*.dar scripts/.daml/dist/*.dar
```

### Kill All DAML Processes
```bash
pkill -f daml || true
```

### Kill Only Sandbox
```bash
pkill -f "daml sandbox" || true
```

---

## 🔁 Reset & Re-run Workflow

### Complete Reset (Fresh Sandbox)
```bash
# Kill existing sandbox
pkill -f "daml sandbox" || true
sleep 3

# Start new sandbox
daml sandbox --port 6865 --json-api-port 7575 &
sleep 8

# Re-upload both DARs
daml ledger upload-dar .daml/dist/dao-maker-1.0.0.dar --host localhost --port 6865
daml ledger upload-dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar --host localhost --port 6865
sleep 1

# Run workflow again (idempotent - safe to repeat)
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:testCompleteWorkflow \
  --ledger-host localhost --ledger-port 6865 2>&1 | tail -80
```

---

## 📊 Expected Output Example

```
Starting complete DAO workflow...
✅ DAO Created!
Admin: 006bf502dcc5d49be8ac0fd938226ba5c93db9dcba8f41fcbb5d2ce8cf8aa5916eca111220...

--- Setup complete ---

✅ Tokens Issued!
Alice: 0027632f0436dafe007f35ff0dd59a63de3355de3cbdaae0eea428ce52017958c0ca112120...
Bob: 0034ba1261a2c5ccfb5bde5ce35d7ee09f6e44b1f07e68b29d34c5b52c6496f1eeca112120...

--- Tokens issued ---

✅ Alice staked tokens!
✅ Bob staked tokens!

--- Staking complete ---

✅ Proposal created!

--- Proposal created ---

✅ Alice voted!
✅ Bob already voted, skipping...

--- Voting complete ---

✅ Margin account created!
✅ Collateral deposited!
✅ Borrow successful!

=== DAO STATUS ===
Admins: 1, Pools: 1, Treasuries: 1
Proposals: 1, Alice stakes: 1, Bob stakes: 1

=== MARGIN STATUS ===
Owner: Alice
Collateral: 500.0
Borrowed: 200.0
Margin Ratio: 2.5

✅ Complete workflow finished successfully!
```

---

## 💡 Command Tips

| Tip | Command |
|-----|---------|
| **Quick test after changes** | `daml build && daml test` |
| **Test one function** | `daml test --test-pattern functionName` |
| **See real-time output** | Remove `2>&1 \| tail -XX` from script commands |
| **Filter for errors** | `grep -E "(error\|Error\|ERROR\|failed\|Failed)"` |
| **Count passing tests** | `daml test 2>&1 \| grep "passing"` |
| **Save output to file** | `daml script ... > output.log 2>&1` |
| **Re-run last sandbox** | `daml sandbox --port 6865 --json-api-port 7575` |
| **Check port availability** | `netstat -tuln \| grep 6865` |

---

## 🎯 Common Workflows

### Workflow 1: Quick Verification (5 minutes)
```bash
# One-liner: Build, deploy, and verify everything works
daml build && cd scripts && daml build && cd .. && \
pkill -f "daml sandbox" || true && sleep 3 && \
daml sandbox --port 6865 --json-api-port 7575 & sleep 10 && \
daml ledger upload-dar .daml/dist/dao-maker-1.0.0.dar --host localhost --port 6865 && \
daml ledger upload-dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar --host localhost --port 6865 && \
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:testCompleteWorkflow \
  --ledger-host localhost --ledger-port 6865 2>&1 | grep "✅"
```

### Workflow 2: Development & Testing (15 minutes)
```bash
# Build, run all tests, then run complete workflow
daml build && daml test && \
pkill -f "daml sandbox" || true && sleep 3 && \
daml sandbox --port 6865 --json-api-port 7575 & sleep 8 && \
daml ledger upload-dar .daml/dist/dao-maker-1.0.0.dar --host localhost --port 6865 && \
daml ledger upload-dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar --host localhost --port 6865 && \
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:testCompleteWorkflow \
  --ledger-host localhost --ledger-port 6865 2>&1 | tail -80
```

### Workflow 3: Interactive Testing (30 minutes)
```bash
# Start sandbox once, then run individual scripts as needed
pkill -f "daml sandbox" || true && sleep 3
daml sandbox --port 6865 --json-api-port 7575 &
sleep 8

# Upload DARs
daml ledger upload-dar .daml/dist/dao-maker-1.0.0.dar --host localhost --port 6865
daml ledger upload-dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar --host localhost --port 6865

# Now run individual scripts:
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:setupDAO --ledger-host localhost --ledger-port 6865

daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:issueTokens --ledger-host localhost --ledger-port 6865

# ... repeat as needed
```

