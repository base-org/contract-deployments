include ../../Makefile
include ../.env
include .env

##
# Foundry commands
##
transfer-owner:
	forge script --rpc-url $(L1_RPC_URL) \
	TransferOwnershipForcedInclusion \
	--private-key $(SIGNER_PRIVATE_KEY) \
	--sig "run(address,address,address,address,address)" \
	$(L2_PROXY_ADMIN_CONTRACT) $(L1_OPTIMISM_PORTAL) $(OWNER_L1_SAFE) $(OWNER_L2_SAFE) $(SIGNER) --broadcast