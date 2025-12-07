# 🎮 Interactive DAO Guide

Your DAO is deployed! Here's how to interact with it step-by-step.

## 📋 Current Status

- ✅ Canton Sandbox: Running on port 6865
- ✅ Core DAR Deployed: .daml/dist/dao-maker-1.0.0.dar
- ✅ Scripts DAR Deployed: scripts/.daml/dist/dao-maker-scripts-1.0.0.dar
- ✅ Parties Allocated: DAO, Alice, Bob

⚠️ **Important**: Use the **Scripts DAR** (not Core DAR) for all `daml script` commands below

## 🚀 Step-by-Step Usage

### Step 1: Setup DAO

```bash
daml script \
  --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name Interactive:setupDAO \
  --ledger-host localhost \
  --ledger-port 6865
```

This creates:
- DAO Admin contract
- Staking Pool
- Treasury with 10,000 PDAO

### Step 2: Issue Tokens

```bash
daml script \
  --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name Interactive:issueTokens \
  --ledger-host localhost \
  --ledger-port 6865
```

Issues:
- 1,000 PDAO to Alice
- 800 PDAO to Bob

### Step 3: Alice Stakes

```bash
daml script \
  --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name Interactive:aliceStakes \
  --ledger-host localhost \
  --ledger-port 6865
```

Alice stakes her tokens for voting power.

### Step 4: Create Proposal

```bash
daml script \
  --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name Interactive:createProposal \
  --ledger-host localhost \
  --ledger-port 6865
```

Creates a proposal to fund community event.

### Step 5: Vote on Proposal

```bash
# Alice votes
daml script \
  --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name Interactive:aliceVotes \
  --ledger-host localhost \
  --ledger-port 6865

# Bob votes (after Bob stakes his tokens)
daml script \
  --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name Interactive:bobVotes \
  --ledger-host localhost \
  --ledger-port 6865
```

### Step 6: View Status

```bash
daml script \
  --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar \
  --script-name Interactive:viewStatus \
  --ledger-host localhost \
  --ledger-port 6865
```

Shows all active contracts and DAO state.

## 🔧 Canton Console Commands

Inside Canton Console (`daml canton-console --host localhost --port 6865`):

```scala
// Check health
sandbox.health.status

// List all parties
sandbox.parties.list()

// View active contracts for DAO
sandbox.ledger_api.acs.of_party(sandbox.parties.list().find(_.party.uid.id.unwrap.startsWith("DAO")).get.party)

// Exit console
exit
```

## 📊 What You Can Do

1. **Token Management**: Issue, transfer, split, merge tokens
2. **Staking**: Stake tokens to gain voting power
3. **Governance**: Create proposals, vote, execute
4. **Treasury**: Manage DAO funds

## 🎯 Quick Demo Sequence

Run these in order:

```bash
cd /home/daniel/work/daml/dao

# 1. Setup
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar --script-name Interactive:setupDAO --ledger-host localhost --ledger-port 6865

# 2. Issue tokens
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar --script-name Interactive:issueTokens --ledger-host localhost --ledger-port 6865

# 3. Stake
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar --script-name Interactive:aliceStakes --ledger-host localhost --ledger-port 6865

# 4. Create proposal
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar --script-name Interactive:createProposal --ledger-host localhost --ledger-port 6865

# 5. Vote
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar --script-name Interactive:aliceVotes --ledger-host localhost --ledger-port 6865

# 6. Check status
daml script --dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar --script-name Interactive:viewStatus --ledger-host localhost --ledger-port 6865
```

## 🛠️ Troubleshooting

If scripts fail, rebuild and redeploy both packages:

```bash
daml build
cd scripts && daml build
daml ledger upload-dar .daml/dist/dao-maker-1.0.0.dar --host localhost --port 6865
daml ledger upload-dar scripts/.daml/dist/dao-maker-scripts-1.0.0.dar --host localhost --port 6865
```

## 📚 Next Steps

- Extend proposals with more action types
- Add delegation features
- Implement time-weighted voting
- Create automation triggers

Your DAO is live and fully functional! 🎉
