include ../../Makefile
include ../.env
include .env

ifndef LEDGER_ACCOUNT
override LEDGER_ACCOUNT = 0
endif

##
# Commands for transfering ownership of L1 and L2 contracts to corresponding nested multisigs
# with CB and OP as signers
##

.PHONY: sign-l1
sign-l1:
	$(GOPATH)/bin/eip712sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" -- \
	forge script --rpc-url $(L1_RPC_URL) TransferOwnerL1 --sig "sign()"

.PHONY: sign-l2
sign-l2:
	$(GOPATH)/bin/eip712sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" -- \
	forge script --rpc-url $(L2_RPC_URL) TransferOwnerL2 --sig "sign()"

.PHONY: run-l1
run-l1:
	forge script --rpc-url $(L1_RPC_URL) \
	TransferOwnerL1 --sig "run(bytes)" $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" \
	--broadcast

.PHONY: run-l2
run-l2:
	forge script --rpc-url $(L2_RPC_URL) \
	TransferOwnerL2 --sig "run(bytes)" $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" \
	--broadcast
