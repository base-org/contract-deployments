# [DRAFT] Deploy Holocene contracts

## Objective

To support the Holocene Network Upgrade, we need to deploy the latest version of the following contracts:

- [FaultDisputeGame](https://github.com/ethereum-optimism/optimism/blob/8bf7ff60f34a7c5082cec5c56bed1f76cc1893ad/packages/contracts-bedrock/src/dispute/FaultDisputeGame.sol)
- [PermissionedDisputeGame](https://github.com/ethereum-optimism/optimism/blob/8bf7ff60f34a7c5082cec5c56bed1f76cc1893ad/packages/contracts-bedrock/src/dispute/PermissionedDisputeGame.sol)

## Deploying the contracts

### 1. Update repo and move to the appropriate folder:

```
cd contract-deployments
git pull
cd mainnet/2024-12-18-holocene-deployments
make deps
```

### 2. Setup Ledger

Your Ledger needs to be connected and unlocked. The Ethereum
application needs to be opened on Ledger with the message "Application
is ready".

### 3. Deploy the contracts

```
make deploy
```
