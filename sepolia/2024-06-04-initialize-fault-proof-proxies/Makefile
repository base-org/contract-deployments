include ../../Makefile
include ../.env
include .env

ifndef LEDGER_ACCOUNT
override LEDGER_ACCOUNT = 0
endif

##
# Note that --ledger --hd-paths <PATH> can be replaced with --private-key $(PRIVATE_KEY)
# in any command when using a local key.
##

# Initialize FP Proxies

.PHONY: initialize-fault-proof-proxies-sign
initialize-fault-proof-proxies-sign: deps
	$(GOPATH)/bin/eip712sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" -- \
	forge script --rpc-url $(L1_RPC_URL) InitializeFaultProofProxies --sig "sign()"

.PHONY: initialize-fault-proof-proxies-run
initialize-fault-proof-proxies-run: deps
	forge script --rpc-url $(L1_RPC_URL) \
	InitializeFaultProofProxies --sig "run(bytes)" $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" \
	--broadcast
