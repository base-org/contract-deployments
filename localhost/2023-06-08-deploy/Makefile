include ../../Makefile
include ../.env
include .env

##
# Foundry commands
##
.PHONY: deploy
deploy: deps
	go run cmd/foundry_deploy_config_gen/main.go && \
	forge script --rpc-url $(L1_RPC_URL) --private-key $(PRIVATE_KEY) RunDeployBedrock --broadcast && \
	jq --sort-keys . unsorted.json > deployed/addresses.json && cp deployed/addresses.json ../addresses.json && \
	rm unsorted.json && rm inputs/foundry-config.json

# TODO: include deploy-safe-contracts in this command, however right now it surfaces an error - figure out how to ignore this error and move on
.PHONY: transfer-owner-to-safe
transfer-owner-to-safe: create-safe initialize-safe transfer-ownership

# Deploy Safe contracts locally to enable setting up a Safe
deploy-safe-contracts:
	rm -rf lib/safe-contracts
	mkdir -p lib/safe-contracts
	cd lib/safe-contracts; \
	git init; \
	git remote add origin https://github.com/safe-global/safe-contracts.git; \
	git fetch --depth=1 origin $(SAFE_COMMIT); \
	git reset --hard FETCH_HEAD && \
	echo 'MNEMONIC=$(TEST_MNEMONIC)\nETHERSCAN_API_KEY=""\nINFURA_KEY=""' > .env && yarn && \
	NODE_URL=$(L1_RPC_URL) yarn deploy-all custom

# Create a Safe
create-safe:
	cast send $(SAFE_PROXY_FACTORY) "createProxyWithNonce(address,bytes,uint256)" \
	$(SAFE_CODE) '' 1684933447000 --private-key $(PRIVATE_KEY)

# Initialize Safe to be 2 of 3
initialize-safe:
	cast send $(SAFE) "setup(address[],uint256,address,bytes,address,address,uint256,address)" \
	[$(LOCALHOST_ADDR_1),$(LOCALHOST_ADDR_2),$(LOCALHOST_ADDR_3)] 2 0x0000000000000000000000000000000000000000 '' \
	$(FALLBACK_HANDLER) 0x0000000000000000000000000000000000000000 0 \
	0x0000000000000000000000000000000000000000 --private-key $(PRIVATE_KEY)

# Transfer ownership of L1 contracts to Safe
transfer-ownership:
	cast send $(PROXY_ADMIN) "transferOwnership(address)" $(SAFE) --private-key $(PRIVATE_KEY)

# Deploy Multicall3 contract
deploy-multicall3:
	forge create Multicall3 --rpc-url $(L1_RPC_URL) --private-key $(PRIVATE_KEY)