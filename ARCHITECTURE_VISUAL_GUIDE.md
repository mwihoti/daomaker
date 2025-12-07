# DAO Maker - Architecture & Visual Guide

## 🏗️ System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        CANTON NETWORK (Distributed Ledger)               │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │                       DAO MAKER SYSTEM                            │  │
│  │                                                                   │  │
│  │  ┌─────────────────────┐      ┌──────────────────────────────┐  │  │
│  │  │  GOVERNANCE LAYER   │      │    MARGIN PROTOCOL LAYER     │  │  │
│  │  │                     │      │                              │  │  │
│  │  │ ┌─────────────────┐ │      │ ┌────────────────────────┐   │  │  │
│  │  │ │ GovernanceToken │◄────┐ │ │  MarginAccount        │   │  │  │
│  │  │ │ (fungible)      │ │    │ │ │ ┌──────────────────┐ │   │  │  │
│  │  │ │ - Transfer      │ │    └─┼─│ │ Collateral: 500  │ │   │  │  │
│  │  │ │ - Split/Merge   │ │      │ │ │ Borrowed: 250    │ │   │  │  │
│  │  │ │ - Spend         │ │      │ │ │ Ratio: 2.0 >= 1.5│ │   │  │  │
│  │  │ └─────────────────┘ │      │ │ │ Status: ACTIVE   │ │   │  │  │
│  │  │          │           │      │ │ └──────────────────┘ │   │  │  │
│  │  │          ▼           │      │ │                       │   │  │  │
│  │  │ ┌─────────────────┐ │      │ │ ┌──────────────────┐   │  │  │
│  │  │ │ StakingPool     │ │      │ │ │ Choices:         │   │  │  │
│  │  │ │ ┌─────────────┐ │ │      │ │ │ - Deposit        │   │  │  │
│  │  │ │ │ Alice: 500  │ │ │      │ │ │ - Borrow         │   │  │  │
│  │  │ │ │ Bob: 400    │ │ │      │ │ │ - Repay          │   │  │  │
│  │  │ │ │ Total: 900  │ │ │      │ │ │ - Withdraw       │   │  │  │
│  │  │ │ └─────────────┘ │ │      │ │ │ - Check Health   │   │  │  │
│  │  │ └─────────────────┘ │      │ │ └──────────────────┘   │  │  │
│  │  │          │           │      │ └────────────────────────┘   │  │  │
│  │  │          ▼           │      │                               │  │  │
│  │  │ ┌─────────────────┐ │      │ ┌────────────────────────┐   │  │  │
│  │  │ │ Proposal        │ │      │ │ Treasury (Lending Pool)│   │  │  │
│  │  │ │ ┌─────────────┐ │ │      │ │ - Receives deposits    │   │  │  │
│  │  │ │ │ Alice:  FOR │ │ │      │ │ - Lends to margin acct │   │  │  │
│  │  │ │ │ Bob:    FOR │ │ │      │ │ - Tracks repayments    │   │  │  │
│  │  │ │ │ Result: PASS│ │ │      │ └────────────────────────┘   │  │  │
│  │  │ │ └─────────────┘ │ │      │                               │  │  │
│  │  │ └─────────────────┘ │      │ ┌────────────────────────┐   │  │  │
│  │  │                     │      │ │ DAO Config              │   │  │  │
│  │  │ ┌─────────────────┐ │      │ │ - Governance params    │   │  │  │
│  │  │ │ DAOAdmin        │ │      │ │ - Margin requirements  │   │  │  │
│  │  │ │ - Observers:    │ │      │ │ - Risk parameters      │   │  │  │
│  │  │ │   [members]     │ │      │ └────────────────────────┘   │  │  │
│  │  │ └─────────────────┘ │      │                               │  │  │
│  │  └─────────────────────┘      └──────────────────────────────┘  │  │
│  │                                                                   │  │
│  └─────────────────────────────────────────────────────────────────┘  │
│                                                                         │
│  PARTIES:  Alice (trader), Bob (voter), DAO (governance), Network    │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 📊 Data Flow: Margin Protocol

```
STEP 1: USER DEPOSITS COLLATERAL
═════════════════════════════════════════════════════════════════

Alice (owner)
    │
    │ 1. Has 1000 GOV tokens
    │ 2. Wants to deposit 500 as collateral
    │
    ▼
GovernanceToken (500 GOV)
    │ owner: Alice
    │ issuer: DAO
    │ amount: 500
    │
    │ Exercise: Spend (archives token)
    │
    ▼
MarginAccount.DepositCollateral
    │
    │ Verification:
    │ ✓ Token owner == Alice
    │ ✓ Token issuer == DAO
    │ ✓ Amount > 0
    │ ✓ Token amount >= deposit amount
    │
    ▼
MarginAccount (UPDATED)
    │ owner: Alice
    │ dao: DAO
    │ collateralAmount: 500 ← UPDATED
    │ borrowedAmount: 0
    │ marginRatio: 999.0
    │ maintenanceMargin: 1.5
    │
    └─ Status: Ready for borrowing ✓


STEP 2: USER BORROWS AGAINST COLLATERAL
═════════════════════════════════════════════════════════════════

Alice wants to borrow 250 tokens
    │
    ▼
MarginAccount.Borrow
    │
    │ Calculation:
    │ newBorrowed = 0 + 250 = 250
    │ newRatio = 500 / 250 = 2.0
    │
    │ Validation:
    │ ✓ newRatio (2.0) >= maintenanceMargin (1.5)
    │ ✓ Treasury has 250 tokens available
    │
    │ Action:
    │ Transfer 250 from Treasury to Alice
    │
    ▼
MarginAccount (UPDATED)
    │ owner: Alice
    │ collateralAmount: 500
    │ borrowedAmount: 250 ← UPDATED
    │ marginRatio: 2.0 ← UPDATED
    │
    │ Treasury (UPDATED)
    │ balance: -250
    │
    └─ Status: Borrow successful ✓


STEP 3: USER MAINTAINS POSITION
═════════════════════════════════════════════════════════════════

Alice can now:

Option A: REPAY DEBT
    │
    └─ Exercise Repay
        - Provide 250 tokens
        - Deposit back to Treasury
        - borrowedAmount: 250 → 0
        - marginRatio: 999.0

Option B: WITHDRAW COLLATERAL
    │
    └─ Exercise WithdrawCollateral
        - Can only withdraw if new ratio >= 1.5
        - Max withdraw: 375 tokens (keep ratio = 1.5)
        - Remaining collateral: 125
        - Receives: 375 tokens

Option C: BORROW MORE
    │
    └─ Exercise Borrow again
        - Can borrow up to: 500 / 1.5 - 250 = 83.33 more
        - Max new borrowed: 333.33
        - Would maintain ratio: 500/333.33 = 1.5
```

---

## 🔄 Complete Workflow Sequence

```
TIME    ACTION                    PARTICIPANT    STATE CHANGE
────────────────────────────────────────────────────────────────────────

T=0     DAO Setup                DAO Admin       DAOConfig created
                                                StakingPool initialized
                                                Treasury initialized

T=1     Issue Tokens             DAO Admin       Alice: +1000 GOV
                                                Bob: +800 GOV

T=2     Alice Stakes             Alice           StakedPosition: 500
                                                Voting power: 500

T=3     Bob Stakes               Bob             StakedPosition: 400
                                                Voting power: 400

T=4     Create Proposal          Alice           Proposal created
                                                Status: ACTIVE
                                                Quorum needed: 900

T=5     Alice Votes FOR           Alice           Vote recorded
                                                Alice: FOR (500 votes)

T=6     Bob Votes FOR             Bob             Vote recorded
                                                Bob: FOR (400 votes)

T=7     Finalize Proposal        DAO             Status: PASSED
                                                Total votes: 900/900
                                                Auto-execute: YES

T=8     Create Margin Account    Alice, DAO      MarginAccount created
                                                collateral: 0
                                                borrowed: 0

T=9     Deposit Collateral       Alice, DAO      ⭐ CORE FEATURE
                                                Token Spend → archived
                                                collateral: 500
                                                marginRatio: 999.0

T=10    Borrow Against Collateral Alice, DAO     ⭐ CORE FEATURE
                                                borrowed: 250
                                                marginRatio: 2.0 ✓
                                                Transfer 250 from Treasury

T=11    Check Margin Health      Alice           marginRatio: 2.0 >= 1.5 ✓

T=12    Repay Debt (partial)     Alice           borrowed: 250 → 125
                                                Treasury receives 125
                                                marginRatio: 4.0

T=13    Withdraw Collateral      Alice           Can withdraw 375 safely
                                                collateral: 500 → 125
                                                Receive 375 GOV tokens

T=14    Close Account            Alice, DAO      Account archived
```

---

## 🎯 Key Components Interaction Matrix

```
                    │ Governance │ Staking │ Treasury │ Margin │ DAO Setup
                    │   Token    │  Pool   │          │        │
────────────────────┼────────────┼─────────┼──────────┼────────┼──────────
GovernanceToken     │     -      │  used   │  holds   │ spent  │  issued
────────────────────┼────────────┼─────────┼──────────┼────────┼──────────
StakingPool         │ receives   │    -    │    -     │ DAO    │  created
                    │  tokens    │         │          │ gov    │
────────────────────┼────────────┼─────────┼──────────┼────────┼──────────
Treasury            │ issues     │  -      │    -     │ lends  │ created
                    │ payments   │         │          │ funds  │
────────────────────┼────────────┼─────────┼──────────┼────────┼──────────
MarginAccount       │ deposits   │ DAO     │ borrows  │  -     │ DAO
                    │ repayments │ votes   │ repays   │        │ signatory
────────────────────┼────────────┼─────────┼──────────┼────────┼──────────
Proposal            │ for voting │ power   │ executes │ DAO    │ created
                    │ quorum     │ counted │ transfers│ params │
                    │            │         │          │ change │
────────────────────┼────────────┼─────────┼──────────┼────────┼──────────
DAOConfig           │ controls   │ setup   │ setup    │ params │   -
                    │ issuance   │         │          │ defined│
```

---

## 🔐 Security & Authorization Model

```
┌──────────────────────────────────────────────────────────────┐
│                  AUTHORIZATION REQUIREMENTS                  │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  Action                      Required Signatories            │
│  ────────────────────────────────────────────────────────────│
│                                                              │
│  1. Transfer Token           ✓ Owner                         │
│  2. Split Token              ✓ Owner                         │
│  3. Merge Tokens             ✓ Owner                         │
│  4. Spend Token              ✓ Owner                         │
│                                                              │
│  5. Stake Tokens             ✓ Staker                        │
│  6. Increase Stake           ✓ Staker                        │
│  7. Unstake                  ✓ Staker                        │
│     (blocked if voting active)                              │
│                                                              │
│  8. Create Proposal          ✓ Proposer                      │
│  9. Vote                     ✓ Voter                         │
│  10. Finalize Proposal       ✓ DAO (auto-execute)           │
│                                                              │
│  11. Deposit Collateral      ✓ Owner + DAO                   │
│  12. Borrow                  ✓ Owner + DAO                   │
│  13. Repay                   ✓ Owner + DAO                   │
│  14. Withdraw Collateral     ✓ Owner                         │
│  15. Check Margin Health     ✓ Owner (nonconsuming)         │
│                                                              │
│  16. Transfer from Treasury  ✓ DAO (via proposal)           │
│  17. Deposit to Treasury     ✓ Depositor                     │
│                                                              │
│  18. Accept Invitation       ✓ New Member + DAO             │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

---

## 📈 Contract State Diagram: MarginAccount

```
                          START
                            │
                            ▼
              ┌─────────────────────────┐
              │  Create MarginAccount   │
              │  collateral: 0          │
              │  borrowed: 0            │
              │  marginRatio: 999.0     │
              └────────┬────────────────┘
                       │
        ┌──────────────┼──────────────┐
        │              │              │
        ▼              ▼              ▼
   DepositCollateral  Borrow      WithdrawCollateral
        │              │             (can't yet)
        │              │
        ▼              ▼
   [COLLATERAL >0]  [blocked: collateral = 0]
        │
        ├─────────────────┐
        │                 │
        ▼                 ▼
    Borrow*      WithdrawCollateral*
    (now OK)     (if ratio >= 1.5)
        │                 │
        ▼                 ▼
  [BORROWED >0]    [COLLATERAL reduced]
        │                 │
        ├─────┬──────┬────┤
        │     │      │    │
        ▼     ▼      ▼    ▼
     Repay  Borrow  Withdraw  CheckHealth
                              (query only)

Constraints:
  • marginRatio >= maintenanceMargin (1.5)
  • collateral >= 0
  • borrowed >= 0
  • Cannot withdraw if new ratio would violate maintenance margin
  • Cannot borrow if new ratio would violate maintenance margin
```

---

## 💡 Key Innovation: DAO-Governed Risk Parameters

```
┌─────────────────────────────────────────────────────────────┐
│         DAO GOVERNANCE → MARGIN PARAMETERS                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Parameter                Default    Governance Control    │
│  ─────────────────────────────────────────────────────────│
│                                                             │
│  Maintenance Margin       1.5        UpdateParameter       │
│  ↳ Min collateral ratio                proposal via vote   │
│     Required to borrow                                      │
│                                                             │
│  Liquidation Threshold    1.2        UpdateParameter       │
│  ↳ Margin triggers                    proposal (future)     │
│     automatic liquidation                                   │
│                                                             │
│  Liquidation Penalty      5%         UpdateParameter       │
│  ↳ Haircut on liquidation             proposal (future)     │
│     proceeds                                                │
│                                                             │
│  Borrow Fee               0.1%        UpdateParameter       │
│  ↳ Charged per borrow                 proposal (future)     │
│     accrued to treasury                                     │
│                                                             │
│  Max Position Size        100,000 GOV UpdateParameter       │
│  ↳ Per account limit                  proposal (future)     │
│     for risk control                                        │
│                                                             │
│  Treasury Balance Min     50,000 GOV  UpdateParameter       │
│  ↳ Emergency reserve                  proposal (future)     │
│     for system stability                                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘

Example Proposal:
  Title: "Increase Maintenance Margin to 1.7"
  Description: "Market volatility rising, need more collateral"
  Action: UpdateParameter("maintenanceMargin", "1.7")
  Voting: Alice (500) + Bob (400) = 900/900 ✓
  Result: PASSED
  Execution: All future borrows require marginRatio >= 1.7
```

---

## 🎓 Learning Path for Judges

1. **Start**: Read DEMO_PROOF_OF_CONCEPT.md (this file)
2. **Understand**: Review key test: `testCompleteWorkflow` in WorkingInteractive.daml
3. **Verify**: Look at `testDepositTransaction` in DepositTest.daml
4. **Deep Dive**: Examine core templates (Margin.daml, GovernanceToken.daml)
5. **Test**: Run `daml test` to see all 34+ tests passing
6. **Deploy**: Follow DEPLOYMENT.md for Canton Network deployment

---

**Architecture designed for transparency, security, and scalability** ✨
