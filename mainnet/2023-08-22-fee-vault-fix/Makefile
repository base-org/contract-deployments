include ../../Makefile
include ../.env
include .env

##
# Foundry commands
##
.PHONY: deploy-new-implementations
deploy-new-implementations:
	forge script --rpc-url $(L2_RPC_URL) DeployNewFeeVaultsL2 --sig "run(address)" $(DEPLOYER)

ifndef LEDGER_ACCOUNT
override LEDGER_ACCOUNT = 0
endif

##
# Commands for signers to run to test the nested safe
##
.PHONY: sign-op
sign-op:
	$(GOPATH)/bin/eip712sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" -- \
	forge script --via-ir --rpc-url $(L2_RPC_URL) FixFeeVaultsL2 \
	--sig "sign(address)" $(OP_SAFE_ADDR)

.PHONY: sign-cb
sign-cb:
	$(GOPATH)/bin/eip712sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" -- \
	forge script --via-ir --rpc-url $(L2_RPC_URL) FixFeeVaultsL2 \
	--sig "sign(address)" $(CB_SAFE_ADDR)

##
# Commands for faciliators to run to test the nested safe
##

.PHONY: approve-op
approve-op:
	forge script --rpc-url $(L2_RPC_URL) FixFeeVaultsL2 \
	--sig "approve(address,bytes)" $(OP_SAFE_ADDR) $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" --sender $(SENDER) --broadcast

.PHONY: approve-cb
approve-cb:
	forge script --rpc-url $(L2_RPC_URL) FixFeeVaultsL2 \
	--sig "approve(address,bytes)" $(CB_SAFE_ADDR) $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" --sender $(SENDER) --broadcast

execute:
	forge script --rpc-url $(L2_RPC_URL) FixFeeVaultsL2 \
	--sig "run()" --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" \
	--sender $(SENDER) --broadcast
