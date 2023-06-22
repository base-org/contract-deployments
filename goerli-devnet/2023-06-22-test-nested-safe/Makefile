include ../../Makefile
include ../.env
include .env
include .env.local

##
# Foundry commands
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

sign-approval-l1:
	chmod +x ./sign-l1-approve.sh && ./sign-l1-approve.sh

sign-approval-l2:
	chmod +x ./sign-l2-approve.sh && ./sign-l2-approve.sh

sign-l1:
	chmod +x ./sign-l1.sh && ./sign-l1.sh

sign-l2:
	chmod +x ./sign-l2.sh && ./sign-l2.sh