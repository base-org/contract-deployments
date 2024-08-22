include ../../Makefile
include ../.env
include .env

ifndef LEDGER_ACCOUNT
override LEDGER_ACCOUNT = 0
endif

.PHONY: execute
execute:
	forge script --rpc-url $(L1_RPC_URL) --private-key $(PRIVATE_KEY) UpdateBatcherHash

.PHONY: execute-rollback
execute-rollback:
	forge script --rpc-url $(L1_RPC_URL) --private-key $(PRIVATE_KEY) RollbackBatcherHash
