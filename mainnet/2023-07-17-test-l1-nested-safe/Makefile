include ../../Makefile
include ../.env
include .env

ifndef LEDGER_ACCOUNT
override LEDGER_ACCOUNT = 1
endif

.PHONY: deploy-test
deploy-test:
	forge script --rpc-url $(L1_RPC_URL) DeployTestProxy \
	--sig "run(address, address, address)" $(DEPLOYER) $(NESTED_L1_SAFE_ADDR) $(PROXY_ADMIN) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" --gas-limit 500000

##
# Commands to test the nested safe
##

.PHONY: sign-op
sign-op:
	forge script --via-ir --rpc-url $(L1_RPC_URL) $(script) \
	--sig "sign(address)" $(OP_SAFE_ADDR) | \
	tee /dev/stderr | grep -A1 vvvvvvvv | grep -v vvvvvvvv | \
	(cd lib/base-contracts && go run ./cmd/sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0")


.PHONY: sign-cb
sign-cb:
	forge script --via-ir --rpc-url $(L1_RPC_URL) $(script) \
	--sig "sign(address)" $(CB_SAFE_ADDR) | \
	tee /dev/stderr | grep -A1 vvvvvvvv | grep -v vvvvvvvv | \
	(cd lib/base-contracts && go run ./cmd/sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0")

