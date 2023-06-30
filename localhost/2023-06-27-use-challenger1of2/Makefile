include ../../Makefile
include ../.env
include .env

##
# Foundry commands
##
.PHONY: deploy-new-impl
deploy-new-impl:
	forge script --rpc-url $(L1_RPC_URL) DeployL2OOImplementation \
	--sig "run(address,address,address)" $(LOCALHOST_ADDR_1) $(CHALLENGER) $(L2_OUTPUT_ORACLE_PROXY) \
	--private-key $(PRIVATE_KEY) --broadcast

.PHONY: sign
sign:
	forge script --via-ir --rpc-url $(L1_RPC_URL) UpgradeL2OutputOracle --sig "sign()" | \
	grep -A1 vvvvvvvv | grep -v vvvvvvvv | \
	(cd lib/base-contracts && go run ./cmd/sign --private-key $(PRIVATE_KEY))

.PHONY: run
run:
	forge script --via-ir --rpc-url $(L1_RPC_URL) \
	UpgradeL2OutputOracle --sig "run(bytes)" $(SIGNATURES) \
	--private-key $(PRIVATE_KEY_2) \
	--broadcast