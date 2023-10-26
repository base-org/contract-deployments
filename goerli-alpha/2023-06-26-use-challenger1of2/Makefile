include ../../Makefile
include ../.env
include .env
include .env.local

##
# Foundry commands
##
.PHONY: deploy-new-impl
deploy-new-impl:
	forge script --rpc-url $(L1_RPC_URL) DeployL2OOImplementation \
	--sig "run(address,address,address)" $(DEPLOYER) $(CHALLENGER) $(L2_OUTPUT_ORACLE_PROXY) \
	--private-key $(PRIVATE_KEY) --broadcast

ifndef LEDGER_ACCOUNT
override LEDGER_ACCOUNT = 0
endif

##
# NestedMultisigBuilder commands
# The following commands can be used for tasks that utilize the NestedMultisigBuilder.
# Note that --ledger --hd-path <PATH> can be replaced with --private-key $(PRIVATE_KEY)
# in any command when using a local key.
##

.PHONY: step-1
step-1:
	forge script --via-ir --rpc-url $(L1_RPC_URL) UpgradeL2OutputOracle \
	--sig "signApproval(address)" $(SAFE_1_ADDR) | \
	tee /dev/stderr | grep -A1 vvvvvvvv | grep -v vvvvvvvv | \
	(cd lib/base-contracts && go run ./cmd/sign --private-key $(PRIVATE_KEY))

.PHONY: step-2
step-2:
	forge script --via-ir --rpc-url $(L1_RPC_URL) UpgradeL2OutputOracle \
	--sig "runApproval(address,bytes)" $(SAFE_1_ADDR) $(SIGNATURES) \
	--private-key $(PRIVATE_KEY)


.PHONY: step-3
step-3:
	forge script --via-ir --rpc-url $(L1_RPC_URL) UpgradeL2OutputOracle \
	--sig "signTransaction(address)" $(SAFE_2_ADDR) | \
	tee /dev/stderr | grep -A1 vvvvvvvv | grep -v vvvvvvvv | \
	(cd lib/base-contracts && go run ./cmd/sign --private-key $(PRIVATE_KEY))

.PHONY: step-4
step-4:
	forge script --via-ir --rpc-url $(L1_RPC_URL) UpgradeL2OutputOracle \
	--sig "runTransaction(address,bytes)" $(SAFE_2_ADDR) $(SIGNATURES) \
	--private-key $(PRIVATE_KEY)
