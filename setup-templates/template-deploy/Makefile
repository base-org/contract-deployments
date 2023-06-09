include ../.env
include .env

##
# Solidity Setup / Testing
##
solidity-deps:
	forge install github.com/foundry-rs/forge-std --no-commit \
		github.com/OpenZeppelin/openzeppelin-contracts@v4.7.3 \
		github.com/OpenZeppelin/openzeppelin-contracts-upgradeable@v4.7.3 \
		github.com/rari-capital/solmate.git@8f9b23f8838670afda0fd8983f2c41e8037ae6bc && \
	make checkout-op-commit && make checkout-base-contracts-commit

solidity-test:
	forge test --ffi -vvv

checkout-op-commit:
	cd lib && rm -rf optimism && \
	mkdir optimism && cd optimism && \
	git init && \
	git remote add origin https://github.com/ethereum-optimism/optimism.git && \
	git fetch --depth=1 origin $(OP_COMMIT) && \
	git reset --hard FETCH_HEAD && cd ../..

checkout-base-contracts-commit:
	chmod 600 ../../tmp/tmpsshkey && ssh-add ../../tmp/tmpsshkey && \
	cd lib && rm -rf base-contracts && \
	mkdir base-contracts && cd base-contracts && \
	git init && \
	git remote add origin git@github.com:base-org/contracts.git && \
	git fetch --depth=1 origin $(BASE_CONTRACTS_COMMIT) && \
	git reset --hard FETCH_HEAD && cd ../..

##
# Foundry commands
##
deploy:
	go run cmd/foundry_deploy_config_gen/main.go && \
	forge script --rpc-url $(L1_RPC_URL) --private-key $(PRIVATE_KEY) RunDeployBedrock --broadcast && \
	jq --sort-keys . unsorted.json > deployed/addresses.json && cp deployed/addresses.json ../addresses.json && \
	rm unsorted.json && rm inputs/foundry-config.json
