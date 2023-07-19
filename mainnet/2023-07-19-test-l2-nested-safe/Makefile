include ../../Makefile
include ../.env
include .env


.PHONY: deploy-test
deploy-test:
	forge script --rpc-url $(L2_RPC_URL) DeployTestProxy \
	--sig "run(address, address)" $(DEPLOYER) $(NESTED_L2_SAFE_ADDR)

ifndef LEDGER_ACCOUNT
override LEDGER_ACCOUNT = 0
endif

##
# Commands to test the nested safe
##

.PHONY: sign-op
sign-op:
	forge script --via-ir --rpc-url $(L2_RPC_URL) TestNestedL2Safe \
	--sig "signApproval(address)" $(OP_SAFE_ADDR) | \
	tee /dev/stderr | grep -A1 vvvvvvvv | grep -v vvvvvvvv | \
	(cd lib/base-contracts && go run ./cmd/sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0")

.PHONY: run-op
run-op:
	forge script --via-ir --rpc-url $(L2_RPC_URL) TestNestedL2Safe \
	--sig "runApproval(address,bytes)" $(OP_SAFE_ADDR) $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0"


.PHONY: sign-cb
sign-cb:
	forge script --via-ir --rpc-url $(L2_RPC_URL) TestNestedL2Safe \
	--sig "signTransaction(address)" $(CB_SAFE_ADDR) | \
	tee /dev/stderr | grep -A1 vvvvvvvv | grep -v vvvvvvvv | \
	(cd lib/base-contracts && go run ./cmd/sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0")

.PHONY: run-cb
run-cb:
	forge script --via-ir --rpc-url $(L2_RPC_URL) TestNestedL2Safe \
	--sig "runTransaction(address,bytes)" $(CB_SAFE_ADDR) $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0"