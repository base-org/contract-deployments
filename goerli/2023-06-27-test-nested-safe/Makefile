include ../../Makefile
include ../.env
include .env
include .env.local

##
# Foundry commands
##

ifndef LEDGER_ACCOUNT
override LEDGER_ACCOUNT = 0
endif

##
# Deploy Test Contracts
##
.PHONY: deploy-test-l1
deploy-test-l1:
	forge script --rpc-url $(L1_RPC_URL) DeployTest \
	--sig "run(address,address)" $(DEPLOYER) $(NESTED_SAFE_L1) \
	--private-key $(PRIVATE_KEY) --broadcast

.PHONY: deploy-test-l2
deploy-test-l2:
	forge script --rpc-url $(L2_RPC_URL) DeployTest \
	--sig "run(address,address)" $(DEPLOYER) $(NESTED_SAFE_L2) \
	--private-key $(PRIVATE_KEY) --broadcast

##
# Test Nested Safe on L1
##
# Step 1
sign-approval-l1:
	forge script --via-ir --rpc-url $(L1_RPC_URL) \
	TestNestedSafeL1 --sig "signApproval(address)" ${SIGNER_SAFE_1_L1} | grep -A1 vvvvvvvv | grep -v vvvvvvvv | \
	(cd lib/base-contracts && go run ./cmd/sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0")

# Step 2
approve-l1:
	forge script --via-ir --rpc-url $(L1_RPC_URL) \
	TestNestedSafeL1 --sig "runApproval(address,bytes)" $(SIGNER_SAFE_1_L1) $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" --broadcast

# Step 3
sign-l1:
	forge script --via-ir --rpc-url ${L1_RPC_URL} \
	TestNestedSafeL1 --sig "signTransaction(address)" ${SIGNER_SAFE_2_L1} | grep -A1 vvvvvvvv | grep -v vvvvvvvv | \
	(cd lib/base-contracts && go run ./cmd/sign --ledger --hd-paths "m/44'/60'/${LEDGER_ACCOUNT}'/0/0")

# Step 4
execute-l1:
	forge script --via-ir --rpc-url $(L1_RPC_URL) \
	TestNestedSafeL1 --sig "runTransaction(address,bytes)" $(SIGNER_SAFE_2_L1) $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" --broadcast

##
# Test Nested Safe on L2
##
# Step 1
sign-approval-l2:
	forge script --via-ir --rpc-url $(L2_RPC_URL) \
	TestNestedSafeL2 --sig "signApproval(address)" ${SIGNER_SAFE_1_L2} | grep -A1 vvvvvvvv | grep -v vvvvvvvv | \
	(cd lib/base-contracts && go run ./cmd/sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0")

# Step 2
approve-l2:
	forge script --via-ir --rpc-url $(L2_RPC_URL) \
	TestNestedSafeL2 --sig "runApproval(address,bytes)" $(SIGNER_SAFE_1_L2) $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" --broadcast

# Step 3
sign-l2:
	forge script --via-ir --rpc-url ${L2_RPC_URL} \
	TestNestedSafeL2 --sig "signTransaction(address)" ${SIGNER_SAFE_2_L2} | grep -A1 vvvvvvvv | grep -v vvvvvvvv | \
	(cd lib/base-contracts && go run ./cmd/sign --ledger --hd-paths "m/44'/60'/${LEDGER_ACCOUNT}'/0/0")

# Step 4
execute-l2:
	forge script --via-ir --rpc-url $(L2_RPC_URL) \
	TestNestedSafeL2 --sig "runTransaction(address,bytes)" $(SIGNER_SAFE_2_L2) $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" --broadcast