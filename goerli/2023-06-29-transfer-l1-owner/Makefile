include ../../Makefile
include ../.env
include .env

ifndef LEDGER_ACCOUNT
override LEDGER_ACCOUNT = 1
endif

##
# Foundry commands
##
sign:
	forge script --via-ir --rpc-url ${L1_RPC_URL} TransferL1Owner --sig "sign()" | \
	grep -A1 vvvvvvvv | grep -v vvvvvvvv | \
	(cd lib/base-contracts && go run ./cmd/sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0")

run:
	forge script --via-ir --rpc-url $(L1_RPC_URL) \
	TransferL1Owner --sig "run(bytes)" $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" --broadcast
