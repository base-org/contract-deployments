include ../../Makefile
include ../.env
include .env

##
# Foundry commands
##
.PHONY: deploy-local
deploy-local:
	go run cmd/foundry_deploy_config_gen/main.go && \
	forge script -vvvv --rpc-url $(L1_RPC_URL) --private-key $(PRIVATE_KEY) RunDeployBedrock --broadcast && \
	jq --sort-keys . unsorted.json > deployed/addresses.json && cp deployed/addresses.json ../addresses.json && \
	rm unsorted.json && rm inputs/foundry-config.json

.PHONY: transfer-owner-to-safe
transfer-owner-to-safe: create-safe initialize-safe transfer-owner-l1 transfer-owner-system-cfg

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
transfer-owner-l1:
	cast send $(PROXY_ADMIN) "transferOwnership(address)" $(SAFE) --private-key $(PRIVATE_KEY)

# Transfer ownership of SystemConfig contract to Safe
transfer-owner-system-cfg:
	cast send $(SYSTEM_CFG_PROXY) "transferOwnership(address)" $(SAFE) --private-key $(PRIVATE_KEY)
