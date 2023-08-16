include ../../Makefile
include ../.env
include .env

##
# Foundry commands
##
.PHONY: run-test
run-test:
	forge script --rpc-url $(L1_RPC_URL) TestTxs --sig "run(address)" $(ADDR)
