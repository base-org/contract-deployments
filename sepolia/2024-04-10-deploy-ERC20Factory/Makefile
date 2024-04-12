include ../../Makefile
include ../.env
include .env

##
# Deploy command
##
.PHONY: deploy
deploy:
	forge script --rpc-url $(L2_RPC_URL) script/RunERC20FactoryDeploy.s.sol --broadcast && \
	jq --sort-keys . unsorted.json > deployed/addresses.json && cp deployed/addresses.json ../addresses.json && \
	rm unsorted.json && rm inputs/foundry-config.json

verify: 
	forge verify-contract 0x6539a3f5fbf41b3f601c418712a45660f00fdae9 \
	lib/optimism/packages/contracts-bedrock/src/universal/OptimismMintableERC20Factory.sol:OptimismMintableERC20Factory \
	--verifier-url  https://api-sepolia.basescan.org/api --watch

