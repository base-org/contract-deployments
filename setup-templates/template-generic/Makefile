include ../../Makefile
include ../.env
include .env

##
# Foundry commands
##
.PHONY: example
example:
	forge script --rpc-url $(RPC_URL) $(script) --sig "run(address)" $(DEPLOYER) --broadcast

ifndef LEDGER_ACCOUNT
override LEDGER_ACCOUNT = 0
endif

.PHONY: example-ledger
example-ledger:
	forge script --rpc-url $(RPC_URL) $(script) --sender $(SENDER) --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" --broadcast

##
# MultisigBuilder commands
# The following commands can be used for tasks that utilize the MultisigBuilder.
# Note that --ledger --hd-path <PATH> can be replaced with --private-key $(PRIVATE_KEY)
# in any command when using a local key.
##

.PHONY: example-sign
sign:
	forge script --via-ir --rpc-url $(RPC_URL) $(script) --sig "sign()" | \
	grep -A1 vvvvvvvv | grep -v vvvvvvvv | \
	(cd lib/base-contracts && go run ./cmd/sign ---ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0")

.PHONY: example-run
run:
	forge script --via-ir --rpc-url $(RPC_URL) \
	$(script) --sig "run(bytes)" $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" \
	--broadcast

##
# NestedMultisigBuilder commands
# The following commands can be used for tasks that utilize the NestedMultisigBuilder.
# Note that --ledger --hd-path <PATH> can be replaced with --private-key $(PRIVATE_KEY)
# in any command when using a local key.
##

.PHONY: example-step-1
example-step-1:
	forge script --via-ir --rpc-url $(RPC_URL) $(script) \
	--sig "signApproval(address)" $(SAFE_1_ADDR) | \
	grep -A1 vvvvvvvv | grep -v vvvvvvvv | \
	go run ./cmd/sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0"

.PHONY: example-step-2
example-step-2:
	forge script --via-ir --rpc-url $(RPC_URL) $(script) \
	--sig "runApproval(address,bytes)" $(SAFE_1_ADDR) $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0"


.PHONY: example-step-3
example-step-3:
	forge script --via-ir --rpc-url $(RPC_URL) $(script) \
	--sig "signTransaction(address)" $(SAFE_2_ADDR) | \
	grep -A1 vvvvvvvv | grep -v vvvvvvvv | \
	go run ./cmd/sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0"

.PHONY: example-step-4
example-step-4:
	forge script --via-ir --rpc-url $(RPC_URL) $(script) \
	--sig "runTransaction(address,bytes)" $(SAFE_2_ADDR) $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0"
