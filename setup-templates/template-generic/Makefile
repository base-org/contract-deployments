include ../../Makefile
include ../.env
include .env

##
# Foundry commands
##
.PHONY: example
example:
	forge script --rpc-url $(RPC_URL) $(script) --sig "run(address)" $(DEPLOYER) --broadcast

ifndef LEDGER_ACCOUNT
override LEDGER_ACCOUNT = 0
endif

.PHONY: example-ledger
example-ledger:
	forge script --rpc-url $(RPC_URL) $(script) --sender $(SENDER) --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" --broadcast
