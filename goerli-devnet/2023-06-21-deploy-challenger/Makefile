include ../../Makefile
include ../.env
include .env
# include .env.local

##
# Foundry commands
##
.PHONY: deploy-challenger
deploy-challenger:
	forge script -vvvv --rpc-url $(L1_RPC_URL) DeployChallenger \
	--sig "run(address,address,address)" $(SAFE_1) $(SAFE_2) $(L2_OUTPUT_ORACLE_PROXY) \
	--private-key $(PRIVATE_KEY) --broadcast

# deploy-challenger:
# 	forge create --rpc-url $(L1_RPC_URL) Challenger1of2 \
# 	--constructor-args $(SAFE_1) $(SAFE_2) $(L2_OUTPUT_ORACLE_PROXY) \
# 	--private-key $(PRIVATE_KEY)