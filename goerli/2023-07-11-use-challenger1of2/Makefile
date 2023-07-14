include ../../Makefile
include ../.env
include .env

ifndef LEDGER_ACCOUNT
override LEDGER_ACCOUNT = 1
endif

##
# Foundry commands
##
.PHONY: deploy-new-impl
deploy-new-impl:
	forge script --rpc-url $(L1_RPC_URL) DeployL2OOImplementation \
	--sig "run(address,address,address)" $(DEPLOYER) $(CHALLENGER) $(L2_OUTPUT_ORACLE_PROXY)

verify-new-impl:
	forge verify-contract ${L2_OUTPUT_ORACLE_IMPL} L2OutputOracle --constructor-args $(shell cast abi-encode "constructor(uint256,uint256,uint256,uint256,address,address,uint256)" 120 2 0 0 ${PROPOSER} ${CHALLENGER} 12) --verifier ${VERIFIER} --watch --chain-id 5  --verifier-url ${VERIFIER_URL} --compiler-version v0.8.15+commit.e14f2714 --num-of-optimizations=999999 --retries=1

##
# NestedMultisigBuilder commands
##

.PHONY: step-1
step-1:
	forge script --via-ir --rpc-url $(L1_RPC_URL) UpgradeL2OutputOracle \
	--sig "signApproval(address)" $(SAFE_1_ADDR) | \
	grep -A1 vvvvvvvv | grep -v vvvvvvvv | \
	(cd lib/base-contracts && go run ./cmd/sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0")

.PHONY: step-2
step-2:
	forge script --via-ir --rpc-url $(L1_RPC_URL) UpgradeL2OutputOracle \
	--sig "runApproval(address,bytes)" $(SAFE_1_ADDR) $(SIGNATURES) --sender $(SENDER) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" --broadcast

.PHONY: step-3
step-3:
	forge script --via-ir --rpc-url $(L1_RPC_URL) UpgradeL2OutputOracle \
	--sig "runTransaction(address,bytes)" $(SAFE_2_ADDR) ""  --sender $(SENDER) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" --broadcast
