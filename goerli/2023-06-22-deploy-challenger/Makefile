include ../../Makefile
include ../.env
include .env

##
# Foundry commands
##
.PHONY: deploy-challenger
deploy-challenger:
	forge script -vvvv --rpc-url $(L1_RPC_URL) DeployChallenger \
	--sig "run(address,address,address,address)" $(DEPLOYER) $(SAFE_1) $(SAFE_2) $(L2_OUTPUT_ORACLE_PROXY)