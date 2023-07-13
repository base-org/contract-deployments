include ../../Makefile
include ../.env
include .env

##
# Foundry commands
##
.PHONY: deploy
deploy:
	go run cmd/foundry_deploy_config_gen/main.go
	forge script --rpc-url $(L1_RPC_URL) RunDeployBedrock
	jq --sort-keys . unsorted.json > deployed/addresses.json
	cp deployed/addresses.json ../addresses.json
	rm unsorted.json inputs/foundry-config.json


etherscan-verify-l1-implementations:
	forge verify-contract ${PROXY_ADMIN} ProxyAdmin --constructor-args $(shell cast abi-encode "constructor(address)" ${DEPLOYER}) --verifier ${VERIFIER} --watch --chain-id 1  --verifier-url ${VERIFIER_URL} --compiler-version v0.8.15+commit.e14f2714 --num-of-optimizations=999999 --retries=1
	forge verify-contract ${ADDRESS_MANAGER} AddressManager --verifier ${VERIFIER} --watch --chain-id 1  --verifier-url ${VERIFIER_URL} --compiler-version v0.8.15+commit.e14f2714 --num-of-optimizations=999999 --retries=1
	forge verify-contract ${L1_CROSS_DOMAIN_MESSENGER_IMPL} L1CrossDomainMessenger --constructor-args $(shell cast abi-encode "constructor(address)" ${OPTIMISM_PORTAL_PROXY}) --verifier ${VERIFIER} --watch --chain-id 1  --verifier-url ${VERIFIER_URL} --compiler-version v0.8.15+commit.e14f2714 --num-of-optimizations=999999 --retries=1
	forge verify-contract ${L1_STANDARD_BRIDGE_IMPL} L1StandardBridge --constructor-args $(shell cast abi-encode "constructor(address)" ${L1_CROSS_DOMAIN_MESSENGER_PROXY}) --verifier ${VERIFIER} --watch --chain-id 1  --verifier-url ${VERIFIER_URL} --compiler-version v0.8.15+commit.e14f2714 --num-of-optimizations=999999 --retries=1
	forge verify-contract ${L2_OUTPUT_ORACLE_IMPL} L2OutputOracle --constructor-args $(shell cast abi-encode "constructor(uint256,uint256,uint256,uint256,address,address)" 120 2 0 0 ${L2OUTPUT_PROPOSER} ${L2OUTPUT_CHALLENGER}) --verifier ${VERIFIER} --watch --chain-id 1  --verifier-url ${VERIFIER_URL} --compiler-version v0.8.15+commit.e14f2714 --num-of-optimizations=999999 --retries=1
	forge verify-contract ${OPTIMISM_PORTAL_IMPL} OptimismPortal --constructor-args $(shell cast abi-encode "constructor(address,uint256)" ${L2_OUTPUT_ORACLE_PROXY} ${FINALIZATION_PERIOD_SECONDS}) --verifier ${VERIFIER} --watch --chain-id 1  --verifier-url ${VERIFIER_URL} --compiler-version v0.8.15+commit.e14f2714 --num-of-optimizations=999999 --retries=1
	forge verify-contract ${OPTIMISM_MINTABLE_ERC20_FACTORY_IMPL} OptimismMintableERC20Factory --constructor-args $(shell cast abi-encode "constructor(address)" ${L1_STANDARD_BRIDGE_PROXY}) --verifier ${VERIFIER} --watch --chain-id 1  --verifier-url ${VERIFIER_URL} --compiler-version v0.8.15+commit.e14f2714 --num-of-optimizations=999999 --retries=1
	forge verify-contract ${L1_ERC721_BRIDGE_IMPL} L1ERC721Bridge --constructor-args $(shell cast abi-encode "constructor(address,address)" ${L1_CROSS_DOMAIN_MESSENGER_PROXY} ${L2_ERC721_BRIDGE}) --verifier ${VERIFIER} --watch --chain-id 1  --verifier-url ${VERIFIER_URL} --compiler-version v0.8.15+commit.e14f2714 --num-of-optimizations=999999 --retries=1
	forge verify-contract ${PROTAL_SENDER_IMPL} PortalSender --constructor-args $(shell cast abi-encode "constructor(address)" ${OPTIMISM_PORTAL_PROXY}) --verifier ${VERIFIER} --watch --chain-id 1  --verifier-url ${VERIFIER_URL} --compiler-version v0.8.15+commit.e14f2714 --num-of-optimizations=999999 --retries=1
	forge verify-contract ${SYSTEM_CONFIG_IMPL} SystemConfig --constructor-args $(shell cast abi-encode "constructor(address,uint256,uint256,bytes32,uint64,address)" ${SYSTEM_CONFIG_CONSTRUCTOR_ARGS}) --verifier ${VERIFIER} --watch --chain-id 1  --verifier-url ${VERIFIER_URL} --compiler-version v0.8.15+commit.e14f2714 --num-of-optimizations=999999 --retries=1
	forge verify-contract ${SYSTEM_DICTATOR_IMPL} SystemDictator --verifier ${VERIFIER} --watch --chain-id 1 --verifier-url ${VERIFIER_URL} --compiler-version v0.8.15+commit.e14f2714 --num-of-optimizations=999999 --retries=1

etherscan-verifiy-test:
	forge verify-contract ${PROXY_ADMIN} ProxyAdmin --constructor-args $(shell cast abi-encode "constructor(address)" ${DEPLOYER}) --verifier ${VERIFIER} --watch --chain-id 1 --verifier-url ${VERIFIER_URL} --compiler-version v0.8.15+commit.e14f2714 --num-of-optimizations=999999 --retries=1