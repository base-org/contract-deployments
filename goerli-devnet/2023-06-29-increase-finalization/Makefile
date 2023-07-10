include ../../Makefile
include ../.env
include ../.env.local
include .env

##
# Foundry commands
##
.PHONY: deploy-new-impl
deploy-new-impl:
	forge script --rpc-url $(L1_RPC_URL) DeployL2OOImplementation \
	--sig "run(address,uint256,address)" $(DEPLOYER) $(FINALIZATION_PERIOD_SECS) $(L2_OUTPUT_ORACLE_PROXY) \
	--private-key $(PRIVATE_KEY) --broadcast

##
# Commands to upgrade to L2OO which contains longer finalization period
##

.PHONY: step-1
step-1:
	forge script --via-ir --rpc-url $(L1_RPC_URL) UpgradeL2OutputOracle \
	--sig "signApproval(address)" $(SAFE_1_ADDR) | \
	grep -A1 vvvvvvvv | grep -v vvvvvvvv | \
	(cd lib/base-contracts && go run ./cmd/sign --private-key $(PRIVATE_KEY))

.PHONY: step-2
step-2:
	forge script --via-ir --rpc-url $(L1_RPC_URL) UpgradeL2OutputOracle \
	--sig "runApproval(address,bytes)" $(SAFE_1_ADDR) $(SIGNATURES) \
	--private-key $(PRIVATE_KEY) --broadcast

.PHONY: step-3
step-3:
	forge script --via-ir --rpc-url $(L1_RPC_URL) UpgradeL2OutputOracle \
	--sig "runTransaction(address,bytes)" $(SAFE_2_ADDR) "" \
	--private-key $(PRIVATE_KEY) --broadcast

##
# Commands to revert back to L2OO which contains faster finalization period
##

.PHONY: step-1-revert
step-1-revert:
	forge script --via-ir --rpc-url $(L1_RPC_URL) RevertL2OutputOracle \
	--sig "signApproval(address)" $(SAFE_1_ADDR) | \
	grep -A1 vvvvvvvv | grep -v vvvvvvvv | \
	(cd lib/base-contracts && go run ./cmd/sign --private-key $(PRIVATE_KEY))

.PHONY: step-2-revert
step-2-revert:
	forge script --via-ir --rpc-url $(L1_RPC_URL) RevertL2OutputOracle \
	--sig "runApproval(address,bytes)" $(SAFE_1_ADDR) $(SIGNATURES) \
	--private-key $(PRIVATE_KEY)

.PHONY: step-3-revert
step-3-revert:
	forge script --via-ir --rpc-url $(L1_RPC_URL) RevertL2OutputOracle \
	--sig "runTransaction(address,bytes)" $(SAFE_2_ADDR) "" \
	--private-key $(PRIVATE_KEY)
