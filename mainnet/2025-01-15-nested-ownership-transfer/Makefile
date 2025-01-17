include ../../Makefile
include ../.env
include .env

ifndef LEDGER_ACCOUNT
override LEDGER_ACCOUNT = 0
endif

##
# MultisigBuilder commands
##

# Step 1a
.PHONY: sign-add-signer
sign-add-signer:
	$(GOPATH)/bin/eip712sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" -- \
	forge script --rpc-url $(L1_RPC_URL) AddSigner --sig "sign()"

# Step 1b
.PHONY: run-add-signer
run-add-signer:
	forge script --rpc-url $(L1_RPC_URL) \
	AddSigner --sig "run(bytes)" $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" \
	--broadcast

# Step 2a
.PHONY: sign-remove-signer
sign-remove-signer:
	$(GOPATH)/bin/eip712sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" -- \
	forge script --rpc-url $(L1_RPC_URL) RemoveSigner --sig "sign()"

# Step 2b
.PHONY: run-remove-signer
run-remove-signer:
	forge script --rpc-url $(L1_RPC_URL) \
	RemoveSigner --sig "run(bytes)" $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" \
	--broadcast

##
# NestedMultisigBuilder commands
##

# Step 3a
.PHONY: sign-add-nested-signer
sign-add-nested-signer:
	$(GOPATH)/bin/eip712sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" -- \
	forge script --rpc-url $(L1_RPC_URL) AddNestedSigner \
	--sig "sign(address)" $(SIGNER_NEW)

# Step 3b
.PHONY: approve-add-nested-signer
approve-add-nested-signer:
	forge script --rpc-url $(L1_RPC_URL) AddNestedSigner \
	--sig "approve(address,bytes)" $(SIGNER_NEW) $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" --broadcast

# Step 3c
.PHONY: execute-add-nested-signer
execute-add-nested-signer:
	forge script --rpc-url $(L1_RPC_URL) AddNestedSigner \
	--sig "run()" --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" --broadcast
