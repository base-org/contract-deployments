include ../../Makefile
include ../.env
include .env

##
# Foundry commands
##
ifndef LEDGER_ACCOUNT
override LEDGER_ACCOUNT = 0
endif

.PHONY: transfer-owner
transfer-owner:
	forge script --rpc-url $(L1_RPC_URL) TransferSystemConfigOwner \
	--sender $(SENDER) --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" \
	--sig "run(address)" $(CB_OWNER_SAFE)
