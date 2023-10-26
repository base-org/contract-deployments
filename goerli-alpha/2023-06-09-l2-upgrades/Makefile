include ../../Makefile
include ../.env
include .env

##
# Foundry commands
##

# Upgrade L2 contracts
l2-upgrade:
	forge script -vvvv --rpc-url $(L2_RPC_URL) \
	RunPostSherlockL2 \
	--sig "run(uint256,address)" $(L2_CHAIN_ID) $(OWNER_L2) \
	--private-key $(SIGNER_PRIVATE_KEY) --broadcast