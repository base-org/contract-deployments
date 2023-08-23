include ../../Makefile
include ../.env
include .env
include .env.local

##
# Foundry commands
##
.PHONY: deploy-balance-tracker
deploy-balance-tracker:
	@forge script DeployBalanceTracker --rpc-url $(L1_RPC_URL) --sig "run()" --private-key ${PRIVATE_KEY} --verify --verifier-url ${VERIFIER_URL} --verifier ${VERIFIER} --chain-id 5 --retries 2

.PHONY: deploy-fee-disburser
deploy-fee-disburser:
	@forge script DeployFeeDisburser --rpc-url $(L2_RPC_URL) --sig "run()" --broadcast --private-key ${PRIVATE_KEY} 

.PHONY: verify-balance-tracker
verify-balance-tracker:
	@forge verify-contract ${BALANCE_TRACKER_IMPL} ./lib/base-contracts/src/revenue-share/BalanceTracker.sol:BalanceTracker --verifier ${VERIFIER} --verifier-url ${VERIFIER_URL}  --chain-id ${BALANCE_TRACKER_CHAIN_ID} --num-of-optimizations=99999 --retries=1 --compiler-version v0.8.15+commit.e14f2714 --etherscan-api-key ${ETHERSCAN_API_KEY} --watch 
	@forge verify-contract ${BALANCE_TRACKER_PROXY} Proxy --constructor-args $(shell cast abi-encode "constructor(address)" ${BALANCE_TRACKER_DEPLOYER}) --verifier ${VERIFIER} --verifier-url ${VERIFIER_URL} --chain-id ${BALANCE_TRACKER_CHAIN_ID} --num-of-optimizations=99999 --retries=1 --compiler-version v0.8.15+commit.e14f2714 --etherscan-api-key ${ETHERSCAN_API_KEY} --watch 

.PHONY: verify-fee-disburser
verify-fee-disburser:
	@forge verify-contract ${FEE_DISBUSER_IMPL} ./lib/base-contracts/src/revenue-share/FeeDisburser.sol:FeeDisburser --constructor-args $(shell cast abi-encode "constructor(address,address,uint256)" ${OPTIMISM_WALLET} ${BALANCE_TRACKER} ${FEE_DISBURSEMENT_INTERVAL}) --verifier ${VERIFIER} --verifier-url ${VERIFIER_URL} --chain-id ${FEE_DISBUSER_CHAIN_ID} --num-of-optimizations=99999 --retries=1 --compiler-version v0.8.15+commit.e14f2714 --watch 
	@forge verify-contract ${FEE_DISBUSER_PROXY} Proxy --constructor-args $(shell cast abi-encode "constructor(address)" ${BALANCE_TRACKER_DEPLOYER}) --verifier ${VERIFIER} --verifier-url ${VERIFIER_URL} --chain-id ${FEE_DISBUSER_CHAIN_ID} --num-of-optimizations=99999 --retries=1 --compiler-version v0.8.15+commit.e14f2714 --watch 
