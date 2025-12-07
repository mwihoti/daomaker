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

## 📚 References

- [Canton Documentation](https://docs.digitalasset.com/build/3.4/quickstart/operate/explore-the-demo.html)
- [Daml Tutorials](https://www.youtube.com/watch?v=xsuMDLED6gI&t=34s)
- [Daml Language Reference](https://docs.daml.com/)

## 🤝 Contributing

This is a complete reference implementation. To extend:
- Add more proposal action types
- Implement delegation
- Add time-weighted voting
- Create automated triggers
- Add multi-sig requirements

## 📝 License

This project is provided as-is for educational and production use on Canton Network.

## ✅ Implementation Checklist

- [x] Governance token with full operations
- [x] Staking system with locking mechanism
- [x] Proposal creation and approval workflow
- [x] Voting with stake-based power
- [x] Quorum and time-based finalization
- [x] Automatic execution of passed proposals
- [x] Treasury with deposit/transfer/yield distribution
- [x] Complete DAO initialization
- [x] Member invitation system
- [x] Comprehensive test suite
- [x] No database dependencies
- [x] No frontend requirements
- [x] Fully on-chain implementation

---

**Built with ❤️ on Canton Network using Daml**
