## [DRAFT] Upgrade to new system config with 400m max gas limit

Base is continuing to scale and we need higher block gas limit to support the increased demand.

### Steps

1. pull main branch of https://github.com/base-org/contract-deployments:
`git clone git@github.com:base-org/contract-deployments.git`

2. ledger needs to be connected and unlocked
3. deploying contracts (base team):
```shell
cd mainnet/2024-11-18-increase-max-gas-limit
make deps
make deploy
```

4. sign (op team):
```shell
cd mainnet/2024-11-18-increase-max-gas-limit
make deps # skip if already installed
make sign-op
```

5. approve (op team):
```shell
cd mainnet/2024-11-18-increase-max-gas-limit
make deps # skip if already installed
SIGNATURES=xxx make approve-op # replace xxx with actual signatures
```

6. sign (cb team):
```shell
cd mainnet/2024-11-18-increase-max-gas-limit
make deps # skip if already installed
make sign-cb
```

7. approve (cb team):
```shell
cd mainnet/2024-11-18-increase-max-gas-limit
make deps # skip if already installed
SIGNATURES=xxx make approve-cb # replace xxx with actual signatures
```

8. upgrade
```shell
cd mainnet/2024-11-18-increase-max-gas-limit
make run-upgrade
```