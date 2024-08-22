# Update Batcher Hash in L1 `SystemConfig` 

Status: ready to execute

## Objective

We are migrating batcher key on sepolia to a key that is managed by the internal key management service.

This runbook implements scripts which allow `SystemConfig` owner to execute: 
1. `UpdateBatcherHash` -- This script will update the batcher hash in `SystemConfig` to be the new key.
2. `RollbackBatcherHash` -- This script establishes a rollback call in the case we need to revert.

The values we are sending are statically defined in the `.env`.

## 1. Update repo and move to the appropriate folder:
```
cd contract-deployments
git pull
cd sepolia-alpha/2024-08-21-update-batcher-hash
make deps
```

## 2. Simulate and validate the transaction

``` shell
make execute
```

If the private-key is the owner, it should start the foundry simulation. The logs should be
```
== Logs ==
  Current batcherHash: 
  0x000000000000000000000000212dd524932bc43478688f91045f2682913ad8ee
  New batcherHash: 
  0x0000000000000000000000007a43fd33e42054c965ee7175dd4590d2bdba79cb
```

### 3. Execute the transaction

Once the tx is simulated and validated, modify the `Makefile` to add `--broadcast` to the `execute` command.

### 4. Rollback (if needed)

If somehow we need to rollback, we can do the same simulation and execution step as above, but for `make execute-rollback`.

