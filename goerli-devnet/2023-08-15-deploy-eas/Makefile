include ../../Makefile
include ../.env
include .env

.PHONY: deploy-eas
deploy-eas:
	forge script --rpc-url $(L2_RPC_URL) DeployEASImplementation

verify-eas-implementations:
	forge verify-contract ${REGISTRY_IMPL_ADDRESS} ./lib/optimism/packages/contracts-bedrock/src/EAS/SchemaRegistry.sol:SchemaRegistry --verifier ${VERIFIER} --watch --chain-id $(L2_CHAIN_ID)  --verifier-url ${VERIFIER_URL} --compiler-version v0.8.15+commit.e14f2714 --num-of-optimizations=99999 --retries=1
	forge verify-contract ${EAS_IMPL_ADDRESS} ./lib/optimism/packages/contracts-bedrock/src/EAS/EAS.sol:EAS --verifier ${VERIFIER} --watch --chain-id $(L2_CHAIN_ID)  --verifier-url ${VERIFIER_URL} --compiler-version v0.8.15+commit.e14f2714 --num-of-optimizations=99999 --retries=1
