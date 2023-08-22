include ../../Makefile
include ../.env
include .env

##
# Foundry commands
##
.PHONY: run-test
run-test:
	forge script --rpc-url $(L1_RPC_URL) TestTxs --sig "run(address)" $(ADDR)

.PHONY: run-test-l2
run-test-l2:
	forge script --rpc-url $(L2_RPC_URL) TestTxs --sig "run(address)" $(ADDR)
