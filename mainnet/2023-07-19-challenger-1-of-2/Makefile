include ../../Makefile
include ../.env
include .env

ifndef LEDGER_ACCOUNT
override LEDGER_ACCOUNT = 0
endif

##
# Foundry commands
##
.PHONY: deploy-challenger
deploy-challenger:
	forge script -vvvv --rpc-url $(L1_RPC_URL) DeployChallenger \
	--sig "run(address,address,address,address)" $(DEPLOYER) $(OP_SAFE) $(CB_SAFE) $(L2_OUTPUT_ORACLE_PROXY)


##
# Testing commands for OP
##

.PHONY: test-challenger
test-challenger: deps
	@forge script --via-ir --rpc-url $(L1_RPC_URL) TestChallenger --sig "sign()" | \
	tee /dev/stderr | grep -A1 vvvvvvvv | grep -v vvvvvvvv | \
	(cd lib/base-contracts && go run ./cmd/sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0")

.PHONY: test-challenger-run
test-challenger-run: deps
	@forge script --via-ir --rpc-url $(L1_RPC_URL) \
	TestChallenger --sig "run(bytes)" $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" \
	--broadcast


##
# Testing commands for CB
##

.PHONY: test-challenger-cb
test-challenger-cb: deps
	@forge script --via-ir --rpc-url $(L1_RPC_URL) TestChallenger2 --sig "sign()" | \
	tee /dev/stderr | grep -A1 vvvvvvvv | grep -v vvvvvvvv | \
	(cd lib/base-contracts && go run ./cmd/sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0")

.PHONY: test-challenger-cb-run
test-challenger-cb-run: deps
	@forge script --via-ir --rpc-url $(L1_RPC_URL) \
	TestChallenger2 --sig "run(bytes)" $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" \
	--broadcast
