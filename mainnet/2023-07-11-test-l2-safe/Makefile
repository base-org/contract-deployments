include ../../Makefile
include ../.env
include .env

##
# Foundry commands
##
.PHONY: deploy-test
deploy-test:
	forge script --rpc-url $(L2_RPC_URL) DeployTestProxy \
	--sig "run(address, address)" $(DEPLOYER) $(L2_SAFE) --broadcast

##
# MultisigBuilder commands
##
ifndef LEDGER_ACCOUNT
override LEDGER_ACCOUNT = 0
endif

.PHONY: sign
sign:
	forge script --via-ir --rpc-url $(L2_RPC_URL) TestL2Safe --sig "sign()" | \
	grep -A1 vvvvvvvv | grep -v vvvvvvvv | \
	(cd lib/base-contracts && go run ./cmd/sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0")

.PHONY: run
run:
	forge script --via-ir --rpc-url $(L2_RPC_URL) \
	TestL2Safe --sig "run(bytes)" $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" \
	--broadcast
