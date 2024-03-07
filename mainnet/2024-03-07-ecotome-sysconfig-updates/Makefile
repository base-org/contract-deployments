include ../../Makefile
include ../.env
include .env

ifndef LEDGER_ACCOUNT
override LEDGER_ACCOUNT = 0
endif

.PHONY: sign-update-gas-config
sign-update-gas-config: 
	$(GOPATH)/bin/eip712sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" -- \
	forge script --rpc-url $(L1_RPC_URL) UpdateGasConfig \
	--sig "sign()"

.PHONY: approve-update-gas-config
approve-update-gas-config:
	forge script --rpc-url $(L1_RPC_URL) UpdateGasConfig \
	--sig "approve(address,bytes)" $(SYSTEM_CONFIG_OWNER) $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" \
	--broadcast

.PHONY: execute
execute:
	forge script --rpc-url $(L1_RPC_URL) UpdateGasConfig \
	--sig "run()" --ledger -hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0"
