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

goerli-prod-upgrade-l2oo:
	@forge script --rpc-url $(L1_RPC_URL) L2OutputOracleUpgrade -vvvv --sig "run(address)" $(SENDER) --ledger --hd-paths ${LEDGER_ACCOUNT}