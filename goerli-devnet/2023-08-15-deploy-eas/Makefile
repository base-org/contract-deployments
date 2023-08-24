include ../../Makefile
include ../.env
include .env

.PHONY: deps-special
deps-special: install-eip712sign clean-lib forge-deps checkout-eas-commit

.PHONY: forge-deps
forge-deps:
	forge install --no-git github.com/foundry-rs/forge-std \
		github.com/OpenZeppelin/openzeppelin-contracts@v4.9.3 \
		github.com/OpenZeppelin/openzeppelin-contracts-upgradeable@v4.9.3 \
		github.com/rari-capital/solmate@8f9b23f8838670afda0fd8983f2c41e8037ae6bc

.PHONY: checkout-eas-commit
checkout-eas-commit:
	[ -n "$(EAS_COMMIT)" ] || (echo "EAS_COMMIT must be set in .env" && exit 1)
	rm -rf lib/eas-contracts
	mkdir -p lib/eas-contracts
	cd lib/eas-contracts; \
	git init; \
	git remote add origin git@github.com:ethereum-attestation-service/eas-contracts.git; \
	git fetch --depth=1 origin $(EAS_COMMIT); \
	git reset --hard FETCH_HEAD

.PHONY: deploy-eas
deploy-eas:
	forge script --rpc-url $(L2_RPC_URL) DeployEASImplementation

verify-eas-implementations:
	forge verify-contract ${REGISTRY_IMPL_ADDRESS} ./lib/eas-contracts/contracts/SchemaRegistry.sol:SchemaRegistry --verifier ${VERIFIER} --watch --chain-id $(L2_CHAIN_ID)  --verifier-url ${VERIFIER_URL} --compiler-version v0.8.15+commit.e14f2714 --num-of-optimizations=99999 --retries=1
	forge verify-contract ${EAS_IMPL_ADDRESS} ./lib/eas-contracts/contracts/EAS.sol:EAS --constructor-args $(shell cast abi-encode "constructor(address)" ${REGISTRY_PROXY_ADDRESS}) --verifier ${VERIFIER} --watch --chain-id $(L2_CHAIN_ID)  --verifier-url ${VERIFIER_URL} --compiler-version v0.8.15+commit.e14f2714 --num-of-optimizations=99999 --retries=1
