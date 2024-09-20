include ../../Makefile
include ../.env
include .env

ifndef LEDGER_ACCOUNT
override LEDGER_ACCOUNT = 1
endif

.PHONY: sign-upgrade
sign-upgrade: 
	$(GOPATH)/bin/eip712sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" -- \
	forge script --rpc-url $(L1_RPC_URL) Upgrade \
	--sig "sign()"

.PHONY: execute-upgrade
execute-upgrade:
	forge script --rpc-url $(L1_RPC_URL) Upgrade \
	--sig "run(bytes)" $(SIGNATURES) --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" --broadcast


.PHONY: sign-rollback
sign-rollback: 
	$(GOPATH)/bin/eip712sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" -- \
	forge script --rpc-url $(L1_RPC_URL) Rollback \
	--sig "sign()"


.PHONY: execute-rollback
execute-rollback:
	forge script --rpc-url $(L1_RPC_URL) Rollback \
	--sig "run(bytes)" $(SIGNATURES) --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" --broadcast
