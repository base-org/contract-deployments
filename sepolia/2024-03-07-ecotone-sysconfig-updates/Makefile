include ../../Makefile
include ../.env
include .env

ifndef LEDGER_ACCOUNT
override LEDGER_ACCOUNT = 0
endif

# Unpause OptimismPortal Commands

.PHONY: update-gas-config
update-gas-config:
	forge script --rpc-url $(L1_RPC_URL) UpdateGasConfigSepolia --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" --broadcast
