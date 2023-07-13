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

verify-challenger:
	forge verify-contract ${CHALLENGER} Challenger1of2 --constructor-args $(shell cast abi-encode "constructor(address,address,address)" ${SAFE_1} ${SAFE_2} ${L2_OUTPUT_ORACLE_PROXY}) --verifier ${VERIFIER} --watch --chain-id 5 --verifier-url ${VERIFIER_URL} --compiler-version v0.8.15+commit.e14f2714 --num-of-optimizations=999999 --retries=1