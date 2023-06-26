include ../../Makefile
include ../.env
include .env
include .env.local

##
# Foundry commands
##
sign:
	forge script --via-ir --rpc-url ${L2_RPC_URL} TransferL2Owner --sig "sign()" | \
	grep -A1 vvvvvvvv | grep -v vvvvvvvv | \
	(cd lib/base-contracts && go run ./cmd/sign --private-key ${PRIVATE_KEY})

run:
	forge script --via-ir --rpc-url $(L2_RPC_URL) \
	TransferL1Owner --sig "run(bytes)" $(SIGNATURES) \
	--private-key $(PRIVATE_KEY) --broadcast
