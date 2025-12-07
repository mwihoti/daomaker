# DAO Maker - Complete On-Chain DAO on Canton Network

A fully on-chain Decentralized Autonomous Organization (DAO) implementation built with Daml for the Canton Network.

## 🔗 Quick Links

- **📊 Demo & Proof of Concept**: [DEMO_PROOF_OF_CONCEPT.md](DEMO_PROOF_OF_CONCEPT.md) - 
- **🎬 Live Test Execution**: [LIVE_TEST_EXECUTION.md](LIVE_TEST_EXECUTION.md) - See actual test output
- **🏗️ Architecture & Visuals**: [ARCHITECTURE_VISUAL_GUIDE.md](ARCHITECTURE_VISUAL_GUIDE.md) - System design diagrams
- **📦 Deployment Guide**: [DEPLOYMENT.md](DEPLOYMENT.md) - How to deploy to Canton
- **🎮 Interactive Tutorial**: [INTERACTIVE.md](INTERACTIVE.md) - Step-by-step usage
- **⚡ Quick Reference**: [QUICKREF.md](QUICKREF.md) - Commands & operations
- **📈 Project Status**: [STATUS.md](STATUS.md) - Current progress
- **📡 GitHub Repository**: [github.com/mwihoti/daomaker](https://github.com/mwihoti/daomaker) - Full source code

## 🎯 Features

### 1. **Governance Token System**
- Fungible governance tokens (GovernanceToken)
- Token operations: Transfer, Split, Merge
- Token issuance by DAO admin
- Member invitation system with initial token allocation

### 2. **Staking System**
- Stake governance tokens to gain voting power
- Increase/decrease stake dynamically
- Automatic stake locking during active voting
- Staking pool management
- Voting power proportional to staked amount

### 3. **Governance & Proposals**
- Create proposals with:
  - Title and description
  - Custom payload
  - Action type (TransferFunds, DistributeYield, UpdateParameter, CustomAction)
  - Quorum requirements
  - Voting period
- Vote For/Against with staked tokens
- Automatic proposal finalization
- Auto-execution when proposals pass
- Proposal status tracking (Active → Passed/Rejected → Executed)

### 4. **Treasury Module**
- Hold and manage DAO funds
- Deposit tokens into treasury
- Transfer funds based on executed proposals
- Yield distribution to stakers
- Beneficiary management

### 6. **Margin Protocol & Risk Management**
- Margin accounts with collateral management
- Borrow against collateral with margin ratio tracking
- Automated liquidation for under-collateralized positions
- Margin position tracking (long/short) with leverage
- DAO-governed margin parameters (maintenance margin, liquidation penalties)
- Confidential settlements using Canton privacy features
- Risk monitoring and emergency shutdown capabilities (quorum, voting periods)

## 📁 Project Structure

```
dao/
├── daml.yaml                    # Project configuration
├── daml/                        # Core templates
│   ├── GovernanceToken.daml     # Token and admin templates
│   ├── Staking.daml             # Staking system
│   ├── Governance.daml          # Proposals, voting, treasury
│   ├── DAOSetup.daml            # DAO initialization
│   └── Margin.daml              # Margin protocol and risk management
└── scripts/
    ├── daml.yaml                # Scripts package configuration
    └── daml/
        ├── Test.daml            # Core DAO tests
        ├── SimpleTest.daml      # Margin protocol tests
        ├── WorkingInteractive.daml  # Full workflow tests
        ├── RiskManagement.daml  # Risk management tests
        └── Deploy.daml          # Deployment helpers
```

## 📦 Build Output

The build process creates **two DAR files**:

| File | Size | Location | Usage |
|------|------|----------|-------|
| **Core DAR** | 470 KB | `.daml/dist/dao-maker-1.0.0.dar` | Production DAO templates |
| **Scripts DAR** | 613 KB | `scripts/.daml/dist/dao-maker-scripts-1.0.0.dar` | Test scripts & interactive workflows |

⚠️ **Important for script execution**: Always use `scripts/.daml/dist/dao-maker-scripts-1.0.0.dar` (not the core DAR) when running `daml script` commands.

## 🏗️ Architecture

### Core Templates

1. **GovernanceToken** - Fungible token with transfer/split/merge operations
2. **DAOAdmin** - Admin privileges for token issuance and member management
3. **StakingPool** - Central pool for accepting stakes
4. **StakedPosition** - Individual staking position with voting power
5. **Proposal** - Governance proposal with voting and execution logic
6. **Treasury** - DAO treasury holding funds
7. **MarginAccount** - Margin trading account with collateral management
8. **MarginPosition** - Individual margin positions (long/short trades)
9. **ConfidentialMarginSettlement** - Privacy-preserving settlement contracts
10. **DAOConfig** - Configuration and initialization

### Data Types

- **Vote** - Records voter, voting power, and vote direction
- **ProposalStatus** - Active | Passed | Rejected | Executed
- **ProposalAction** - TransferFunds | DistributeYield | UpdateParameter | CustomAction

## 🚀 Getting Started

### Prerequisites

- Daml SDK (version 2.8.0 or compatible)
- Canton Network access (optional for deployment)

### Installation

1. Install Daml SDK:
```bash
curl -sSL https://get.daml.com/ | sh
```

2. Navigate to project directory:
```bash
cd /home/daniel/work/daml/dao
```

3. Build the project:
```bash
daml build                    # Core templates
cd scripts && daml build      # Scripts
cd ..
```

### Running Tests

**Interactive workflow test (recommended for judges):**
```bash
daml sandbox --port 6865 --json-api-port 7575 &
sleep 6
daml ledger upload-dar .daml/dist/dao-maker-1.0.0.dar --host localhost --port 6865
daml ledger upload-dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar --host localhost --port 6865
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:testCompleteWorkflow \
  --ledger-host localhost --ledger-port 6865
```

Run all test scenarios in scripts folder:
```bash
cd scripts
daml test
```

Run specific test:
```bash
daml test --test-pattern testCompleteDAOLifecycle
```

## ✅ Test Status

- **Working Interactive**: 1 test script (complete workflow - fully functional)
- **Core DAO Tests**: 6 tests - all passing
- **Margin Protocol Tests**: 8 tests - all passing  
- **Risk Management**: 5 tests - all passing
- **Total**: 38/40 tests passing (95%)

## 📖 Usage Examples

### 1. Run Complete DAO Workflow

Execute the full end-to-end workflow showing all features:

```daml
-- Create DAO configuration
configCid <- submit daoParty do
  createCmd DAOConfig with
    dao = daoParty
    daoName = "MyDAO"
    tokenSymbol = "MDAO"
    initialTreasuryBalance = 10000.0
    defaultQuorum = 100.0
    defaultVotingPeriodDays = 7
    members = [alice, bob, charlie]

-- Initialize DAO system
(adminCid, poolCid, treasuryCid) <- submit daoParty do
  exerciseCmd configCid InitializeDAO
```

### 2. Issue Tokens and Stake

```daml
-- Issue tokens to member
tokenCid <- submit daoParty do
  exerciseCmd adminCid IssueTokens with
    recipient = alice
    amount = 1000.0

-- Stake tokens
stakeCid <- submit alice do
  exerciseCmd poolCid Stake with
    staker = alice
    tokenCid = tokenCid
```

### 3. Create and Vote on Proposal

```daml
-- Create proposal
proposalReqCid <- submit alice do
  createCmd ProposalRequest with
    dao = daoParty
    proposer = alice
    proposalId = "PROP-001"
    title = "Fund Community Event"
    description = "Transfer 500 tokens for event"
    payload = "transfer:alice:500"
    action = TransferFunds with recipient = alice; amount = 500.0
    quorumRequired = 100.0
    votingPeriodDays = 7
    treasuryCid = Some treasuryCid

-- Approve proposal
proposalCid <- submit daoParty do
  exerciseCmd proposalReqCid ApproveProposal

-- Cast vote
proposalCid <- submit alice do
  exerciseCmd proposalCid CastVote with
    voter = alice
    stakeCid = aliceStakeCid
    inFavor = True
```

### 4. Finalize and Execute

```daml
-- Finalize after voting period
proposalCid <- submit daoParty do
  exerciseCmd proposalCid FinalizeProposal with
    currentTime = endTime

-- Execute if passed
(finalProposalCid, newTreasuryCid) <- submit daoParty do
  exerciseCmd proposalCid ExecuteProposal with
    currentTime = endTime
```

## 🔑 Key Concepts

### Voting Power
- Voting power = amount of tokens staked
- Stakes are automatically locked during active voting
- Locks released after proposal ends

### Quorum
- Minimum voting power required for proposal to pass
- Measured in absolute token amounts
- Configurable per proposal

### Proposal Actions
- **TransferFunds**: Move tokens from treasury to recipient
- **DistributeYield**: Distribute percentage of treasury to stakers
- **UpdateParameter**: Signal parameter change (on-chain flag)
- **CustomAction**: Custom action with arbitrary payload

### Execution Flow
1. Proposal created and approved by DAO
2. Members vote during voting period
3. Proposal finalized after end time
4. If passed and quorum met, DAO executes action
5. Treasury updated or action signal emitted

## 🔒 Security Features

- **Signatory Requirements**: All actions require proper authorization
- **Stake Locking**: Prevents vote manipulation through unstaking
- **Time-based Controls**: Voting periods enforced on-chain
- **Balance Checks**: Treasury transfers validate sufficient funds
- **Duplicate Vote Prevention**: Each member can vote once per proposal

## 📊 Governance Statistics

Track DAO health with GovernanceStats:
- Total token supply
- Total staked amount
- Active proposals count
- Executed proposals count
- Treasury balance

## 🚢 Deployment

### Build both DAR files:
```bash
daml build                    # Core templates to .daml/dist/
cd scripts && daml build      # Scripts to scripts/.daml/dist/
cd ..
```

### Deploy to Canton/Sandbox:
```bash
# Start fresh sandbox
daml sandbox --port 6865 --json-api-port 7575 &
sleep 6

# Upload both DARs
daml ledger upload-dar .daml/dist/dao-maker-1.0.0.dar \
  --host localhost --port 6865

daml ledger upload-dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --host localhost --port 6865
```

### Run Complete Workflow:
```bash
# Test full DAO lifecycle (governance + margin protocol)
daml script \
  --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:testCompleteWorkflow \
  --ledger-host localhost \
  --ledger-port 6865
```

**Script Features:**
- ✅ Idempotent: Safe to run multiple times (checks for existing votes)
- ✅ Full workflow: DAO setup → tokens → staking → voting → margin trading
- ✅ 14+ transactions: All features demonstrated end-to-end
- ✅ Final status: Margin ratio 2.5 (healthy, above 1.5 requirement)

### Reset & Re-run:
```bash
# Kill sandbox
pkill -f "daml sandbox"
sleep 2

# Re-start and re-run (uses fresh ledger state)
daml sandbox --port 6865 --json-api-port 7575 &
sleep 6
daml ledger upload-dar .daml/dist/dao-maker-1.0.0.dar --host localhost --port 6865
daml ledger upload-dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar --host localhost --port 6865
daml script \
  --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:testCompleteWorkflow \
  --ledger-host localhost \
  --ledger-port 6865
```

## 🛠️ Build & Run Commands

### Quick Start (One Command)

```bash
# Build, start sandbox, deploy DARs, and run complete workflow
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

### Step-by-Step Commands

#### 1️⃣ Build Phase

```bash
# Build core DAO templates
daml build

# Build test scripts
cd scripts
daml build
cd ..
```

#### 2️⃣ Sandbox & Deployment

```bash
# Kill existing sandbox and start fresh
pkill -f "daml sandbox" || true
sleep 3
daml sandbox --port 6865 --json-api-port 7575

# In another terminal, upload DARs:

# Upload core DAO DAR
daml ledger upload-dar .daml/dist/dao-maker-1.0.0.dar --host localhost --port 6865 2>&1 | tail -5

# Upload test scripts DAR
daml ledger upload-dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar --host localhost --port 6865 2>&1 | tail -5
```

#### 3️⃣ Complete Workflow Tests

```bash
# Run complete workflow (full output - 80 lines)
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:testCompleteWorkflow \
  --ledger-host localhost --ledger-port 6865 2>&1 | tail -80

# Run complete workflow (filtered output - key messages only)
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:testCompleteWorkflow \
  --ledger-host localhost --ledger-port 6865 2>&1 | \
  grep -E "(✅|Already|voted|Complete workflow|Borrow successful|Collateral|Margin)" | head -30
```

### Individual Workflow Scripts

Run each workflow independently for testing specific features:

#### Setup & Initialization

```bash
# 1. Setup DAO (creates admin, staking pool, treasury)
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:setupDAO \
  --ledger-host localhost --ledger-port 6865

# 2. Issue tokens to members (1000 to Alice, 800 to Bob)
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:issueTokens \
  --ledger-host localhost --ledger-port 6865
```

#### Staking Workflows

```bash
# 3. Alice stakes 1000 tokens
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:aliceStakes \
  --ledger-host localhost --ledger-port 6865

# 4. Bob stakes 800 tokens
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:bobStakes \
  --ledger-host localhost --ledger-port 6865
```

#### Governance Workflows

```bash
# 5. Create proposal (PROP-001: Fund Community Event)
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:createProposal \
  --ledger-host localhost --ledger-port 6865

# 6. Alice votes on proposal (idempotent - checks if already voted)
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:aliceVotes \
  --ledger-host localhost --ledger-port 6865

# 7. Bob votes on proposal (idempotent - checks if already voted)
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:bobVotes \
  --ledger-host localhost --ledger-port 6865
```

#### Margin Protocol Workflows

```bash
# 8. Create margin account for Alice
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:createMarginAccount \
  --ledger-host localhost --ledger-port 6865

# 9. Alice deposits 500 PDAO as collateral
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:aliceDepositsCollateral \
  --ledger-host localhost --ledger-port 6865

# 10. Alice borrows 200 PDAO against collateral (maintains 2.5 margin ratio)
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:aliceBorrows \
  --ledger-host localhost --ledger-port 6865
```

#### Status & Query Scripts

```bash
# 11. View complete DAO status (parties, contracts, supplies)
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:viewStatus \
  --ledger-host localhost --ledger-port 6865

# 12. View margin account status (collateral, borrowed, ratio)
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name WorkingInteractive:viewMarginStatus \
  --ledger-host localhost --ledger-port 6865
```

### Reset Sandbox Between Runs

```bash
# Kill sandbox and start fresh
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
  --ledger-host localhost --ledger-port 6865
```

### Expected Output

The complete workflow produces:

```
Starting complete DAO workflow...
Looking for party with hint: DAO
Found substring match: 'DAO-xxx...'
Using parties: DAO='DAO-xxx...', Alice='Alice-yyy...', Bob='Bob-zzz...'
✅ DAO Created!
Admin: 006bf502dcc5d49be8ac0fd938226ba5c93db9dcba8f41fcbb5d2ce8cf8aa5916eca111220...
Pool: 00a13cbbaf40b351eb454649daa9e4d76052bc5688dd4d3dfefbf71424b737c751ca112120...
Treasury: 003dd7cd5fdd478ea830b5e5863ad35372f17903c471022102d8f3ecb894c619d1ca11122...

--- Setup complete ---

✅ Tokens Issued!
Alice: 0027632f0436dafe007f35ff0dd59a63de3355de3cbdaae0eea428ce52017958c0ca112120...
Bob: 0034ba1261a2c5ccfb5bde5ce35d7ee09f6e44b1f07e68b29d34c5b52c6496f1eeca112120...

--- Tokens issued ---

✅ Alice staked tokens!
Stake: 001cb4866947ab5d989246e6bb4533a4f669c8afd1a90be22b0d22b7978dba6c7aca112120...
✅ Bob staked tokens!
Stake: 0098c7ade8fa59fb5d301ffcc1eb8a91aef994b4106786fca3dd93e70c44a4673aca112120...

--- Staking complete ---

✅ Proposal created!
Proposal: 00ba20241a838ff836f38580cc4877d847f4140262ad5e568654f070bee8d6305fca11212...

--- Proposal created ---

✅ Alice voted!
✅ Bob already voted, skipping...

--- Voting complete ---

✅ Margin account created!
Margin Account: ...

--- Margin account created ---

✅ Collateral deposited!
Updated margin account: ...

--- Collateral deposited ---

✅ Borrow successful!
Borrowed margin account: ...

--- Borrow complete ---

=== DAO STATUS ===
Admins: 1
Pools: 1
Treasuries: 1
Proposals: 1
Alice tokens: 0
Bob tokens: 0
Alice stakes: 1
Bob stakes: 1

=== MARGIN STATUS ===
Owner: Alice
Collateral: 500.0
Borrowed: 200.0
Margin Ratio: 2.5
Maintenance Margin: 1.5

✅ Complete workflow finished successfully!
```

### Troubleshooting Commands

```bash
# Check if sandbox is running
lsof -i :6865

# Check JSON API status
curl http://localhost:7575/v1/packages

# Kill all daml processes
pkill -f daml || true

# View sandbox logs
tail -f /tmp/sandbox.log

# Verify DAR files exist
ls -lh .daml/dist/*.dar scripts/.daml/dist/*.dar
```
