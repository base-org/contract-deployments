include ../../Makefile
include ../.env
include .env
include .env.local

##
# Foundry commands
##
run:
	forge script --via-ir --rpc-url $(L1_RPC_URL) DeleteL2Outputs \
	--sig "run(bytes)" "" \
	--private-key $(PRIVATE_KEY) --broadcast
