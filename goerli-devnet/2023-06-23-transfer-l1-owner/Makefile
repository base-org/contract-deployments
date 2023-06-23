include ../../Makefile
include ../.env
include .env
include .env.local

##
# Foundry commands
##
sign:
	chmod +x ./sign.sh && ./sign.sh

run:
	forge script --via-ir --rpc-url $(L1_RPC_URL) \
	TransferL1Owner --sig "run(bytes)" $(SIGNATURES) \
	--private-key $(PRIVATE_KEY) --broadcast
