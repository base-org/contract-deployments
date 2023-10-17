include ../../Makefile
include ../.env
include .env

##
# Foundry commands
##
.PHONY: deploy-l2oo
deploy-l2oo:
	forge script --rpc-url $(L2_RPC_URL) DeployUpgradedL2OutputOracle

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
