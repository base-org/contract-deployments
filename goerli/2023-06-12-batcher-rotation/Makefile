include ../../Makefile
include ../.env
include .env

##
# Foundry commands
##
ifndef LEDGER_ACCOUNT
override LEDGER_ACCOUNT = 1
endif

.PHONY: run
run:
	forge script --rpc-url $(RPC_URL) SetBatcherAddr --sender $(SENDER) --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" --sig "run(address,address)" 0x4C35Ca57616E0d5fD808574772f632D8dA4eadCa 0xb15eea247ece011c68a614e4a77ad648ff495bc1 --broadcast
