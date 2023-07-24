include ../../Makefile
include ../.env
include .env

##
# Foundry commands
##
.PHONY: deploy-test
deploy-test:
	forge script --rpc-url $(L1_RPC_URL) DeployTestProxy \
	--sig "run(address, address)" $(LOCALHOST_ADDR_1) $(L1_SAFE) --broadcast \
	--private-key $(PRIVATE_KEY)

##
# MultisigBuilder commands
# The following commands can be used for tasks that utilize the MultisigBuilder.
# Note that --ledger --hd-paths <PATH> can be replaced with --private-key $(PRIVATE_KEY)
# in any command when using a local key.
##

.PHONY: sign
sign:
	forge script --via-ir --rpc-url $(L1_RPC_URL) TestL1Safe --sig "sign()" | \
	grep -A1 vvvvvvvv | grep -v vvvvvvvv | \
	(cd lib/base-contracts && go run ./cmd/sign --private-key $(PRIVATE_KEY))

.PHONY: run
run:
	forge script --via-ir --rpc-url $(L1_RPC_URL) \
	TestL1Safe --sig "run(bytes)" $(SIGNATURES) \
	--private-key $(PRIVATE_KEY_2) \
	--broadcast
