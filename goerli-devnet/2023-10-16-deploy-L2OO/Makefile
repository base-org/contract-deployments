include ../../Makefile
include ../.env
include .env

##
# Foundry commands
##
.PHONY: deploy-l2oo
deploy-l2oo:
	forge script --rpc-url $(L1_RPC_URL) DeployUpgradedL2OutputOracle

verify-l2oo:
	forge verify-contract ${L2_OUTPUT_ORACLE_IMPLEMENTATION} ./lib/optimism/packages/contracts-bedrock/contracts/L1/L2OutputOracle.sol:L2OutputOracle --verifier ${VERIFIER} --watch --chain-id $(L2_CHAIN_ID)  --verifier-url ${VERIFIER_URL} --compiler-version v0.8.15+commit.e14f2714 --num-of-optimizations=99999 --retries=1
##
# Commands for signers to run to test the nested safe
##

.PHONY: sign-op
sign-op:
	$(GOPATH)/bin/eip712sign --private-key ${PRIVATE_KEY} -- \
	forge script --rpc-url $(L2_RPC_URL) UpgradeToEAS \
	--sig "sign(address)" $(OP_SAFE_ADDR)

.PHONY: sign-cb
sign-cb:
	$(GOPATH)/bin/eip712sign --private-key ${PRIVATE_KEY} -- \
	forge script --via-ir --rpc-url $(L2_RPC_URL) UpgradeToEAS \
	--sig "sign(address)" $(CB_SAFE_ADDR)

##
# Commands for faciliators to run to test the nested safe
##

.PHONY: approve-op
approve-op:
	forge script --rpc-url $(L2_RPC_URL) UpgradeToEAS \
	--sig "approve(address,bytes)" $(OP_SAFE_ADDR) $(SIGNATURES) \
	--private-key ${PRIVATE_KEY} --broadcast

.PHONY: approve-cb
approve-cb:
	forge script --rpc-url $(L2_RPC_URL) UpgradeToEAS \
	--sig "approve(address,bytes)" $(CB_SAFE_ADDR) $(SIGNATURES) \
	--private-key ${PRIVATE_KEY} --broadcast

execute:
	forge script --rpc-url $(L2_RPC_URL) UpgradeToEAS \
	--sig "run()" --private-key ${PRIVATE_KEY} --broadcast
