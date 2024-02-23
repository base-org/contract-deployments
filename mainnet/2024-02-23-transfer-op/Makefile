include ../../Makefile
include ../.env
include .env

install-agora:
	forge install --no-git git@github.com:voteagora/optimism-gov.git

.PHONY: sign
sign:
	$(GOPATH)/bin/eip712sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" -- \
	forge script --rpc-url $(OPTIMISM_RPC_URL) TransferAndDelegateOPTokens \
	--sig "sign(address)" $(SIGNER_SAFE_ADDR)

.PHONY: approve
approve:
	forge script --rpc-url $(OPTIMISM_RPC_URL) TransferAndDelegateOPTokens \
	--sig "approve(address,bytes)" $(SIGNER_SAFE_ADDR) $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0"

.PHONY: execute
execute:
	forge script --rpc-url $(OPTIMISM_RPC_URL) TransferAndDelegateOPTokens \
	--sig "run()" --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0"