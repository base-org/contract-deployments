include ../../Makefile
include ../.env
include .env

ifndef LEDGER_ACCOUNT
override LEDGER_ACCOUNT = 0
endif

##
# MultisigBuilder commands
##

.PHONY: sign-add-signer
sign-add-signer:
	$(GOPATH)/bin/eip712sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" -- \
	forge script --rpc-url $(L1_RPC_URL) AddSigner --sig "sign()"

.PHONY: run-add-signer
run-add-signer:
	forge script --rpc-url $(L1_RPC_URL) \
	AddSigner --sig "run(bytes)" $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" \
	--broadcast

.PHONY: sign-remove-signer
sign-remove-signer:
	$(GOPATH)/bin/eip712sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" -- \
	forge script --rpc-url $(L1_RPC_URL) RemoveSigner --sig "sign()"

.PHONY: run-remove-signer
run-remove-signer:
	forge script --rpc-url $(L1_RPC_URL) \
	RemoveSigner --sig "run(bytes)" $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" \
	--broadcast

##
# NestedMultisigBuilder commands
##

.PHONY: sign-add-nested-signer
sign-add-nested-signer:
	$(GOPATH)/bin/eip712sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" -- \
	forge script --rpc-url $(L1_RPC_URL) AddNestedSigner \
	--sig "sign(address)" $(SIGNER_TO_ADD)

.PHONY: approve-add-nested-signer
approve-add-nested-signer:
	forge script --rpc-url $(L1_RPC_URL) AddNestedSigner \
	--sig "approve(address,bytes)" $(SIGNER_TO_ADD) $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" --broadcast

.PHONY: execute-add-nested-signer
execute-add-nested-signer:
	forge script --rpc-url $(L1_RPC_URL) AddNestedSigner \
	--sig "run()" --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" --broadcast

.PHONY: sign-set-threshold
sign-set-threshold:
	$(GOPATH)/bin/eip712sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" -- \
	forge script --rpc-url $(L1_RPC_URL) SetThreshold \
	--sig "sign(address)" $(NESTED_SIGNER_TO_ADD)

.PHONY: approve-set-threshold
approve-set-threshold:
	forge script --rpc-url $(L1_RPC_URL) SetThreshold \
	--sig "approve(address,bytes)" $(NESTED_SIGNER_TO_ADD) $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" --broadcast

.PHONY: execute-set-threshold
execute-set-threshold:
	forge script --rpc-url $(L1_RPC_URL) SetThreshold \
	--sig "run()" --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" --broadcast
