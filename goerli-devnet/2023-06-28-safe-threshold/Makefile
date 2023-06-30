include ../../Makefile
include ../.env
include .env
include ../.env.local

##
# Foundry commands
##
.PHONY: sign
sign:
	forge script --via-ir --rpc-url $(L2_RPC_URL) ChangeThreshold --sig "sign()" | \
	grep -A1 vvvvvvvv | grep -v vvvvvvvv | \
	(cd lib/base-contracts && go run ./cmd/sign --private-key $(PRIVATE_KEY))

.PHONY: run
run:
	forge script --via-ir --rpc-url $(L2_RPC_URL) \
	ChangeThreshold --sig "run(bytes)" $(SIGNATURES) \
	--private-key $(PRIVATE_KEY) --broadcast
