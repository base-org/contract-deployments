include ../../Makefile
include ../.env
include .env
include .env.local

##
# Foundry commands
##

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
	chmod +x ./sign-l1-approve.sh && ./sign-l1-approve.sh

# Step 2
approve-l1:
	forge script --via-ir --rpc-url $(L1_RPC_URL) \
	TestNestedSafeL1 --sig "runApproval(address,bytes)" $(SIGNER_SAFE_1_L1) $(SIGNATURES) \
	--private-key $(PRIVATE_KEY) --broadcast

debug:
	forge script --via-ir --rpc-url ${L1_RPC_URL} TestNestedSafeL1 --sig "signTransaction(address)" ${SIGNER_SAFE_2_L1}

# Step 3
sign-l1:
	chmod +x ./sign-l1.sh && ./sign-l1.sh

# Step 4
execute-l1:
	forge script --via-ir --rpc-url $(L1_RPC_URL) \
	TestNestedSafeL1 --sig "runTransaction(address,bytes)" $(SIGNER_SAFE_2_L1) $(SIGNATURES) \
	--private-key $(PRIVATE_KEY) --broadcast

##
# Test Nested Safe on L2
##
# Step 1
sign-approval-l2:
	chmod +x ./sign-l2-approve.sh && ./sign-l2-approve.sh

# Step 2
approve-l2:
	forge script --via-ir --rpc-url $(L2_RPC_URL) \
	TestNestedSafeL2 --sig "runApproval(address,bytes)" $(SIGNER_SAFE_1_L2) $(SIGNATURES) \
	--private-key $(PRIVATE_KEY)  --broadcast

# Step 3
sign-l2:
	chmod +x ./sign-l2.sh && ./sign-l2.sh

# Step 4
execute-l2:
	forge script --via-ir --rpc-url $(L2_RPC_URL) \
	TestNestedSafeL2 --sig "runTransaction(address,bytes)" $(SIGNER_SAFE_2_L2) $(SIGNATURES) \
	--private-key $(PRIVATE_KEY)  --broadcast
