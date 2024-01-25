include ../../Makefile
include ../.env
include .env

##
# Foundry commands
##
.PHONY: deploy-balance-tracker
deploy-balance-tracker:
	@forge script DeployBalanceTracker --rpc-url $(L1_RPC_URL) --sig "run()"

.PHONY: deploy-fee-disburser
deploy-fee-disburser:
	@forge script DeployFeeDisburser --rpc-url $(L2_RPC_URL) --sig "run()"

.PHONY: verify-balance-tracker
verify-balance-tracker:
	@forge verify-contract ${BALANCE_TRACKER_IMPL} ./lib/base-contracts/src/revenue-share/BalanceTracker.sol:BalanceTracker --verifier ${VERIFIER} --verifier-url ${VERIFIER_URL}  --chain-id ${BALANCE_TRACKER_CHAIN_ID} --retries=1 --etherscan-api-key ${ETHERSCAN_API_KEY} --watch 
	@forge verify-contract ${BALANCE_TRACKER_PROXY} Proxy --constructor-args $(shell cast abi-encode "constructor(address)" ${BALANCE_TRACKER_DEPLOYER}) --verifier ${VERIFIER} --verifier-url ${VERIFIER_URL} --chain-id ${BALANCE_TRACKER_CHAIN_ID} --retries=1 --etherscan-api-key ${ETHERSCAN_API_KEY} --watch 

.PHONY: verify-fee-disburser
verify-fee-disburser:
	ETHERSCAN_API_KEY=PLACEHOLDER_STRING forge verify-contract ${FEE_DISBURSER_IMPL} ./lib/base-contracts/src/revenue-share/FeeDisburser.sol:FeeDisburser --constructor-args $(shell cast abi-encode "constructor(address,address,uint256)" ${OPTIMISM_WALLET} ${BALANCE_TRACKER_PROXY} ${FEE_DISBURSEMENT_INTERVAL}) --verifier ${VERIFIER} --verifier-url ${VERIFIER_URL} --chain-id ${L2_CHAIN_ID} --num-of-optimizations=99999 --retries=1 --compiler-version v0.8.15+commit.e14f2714 --watch 
	ETHERSCAN_API_KEY=PLACEHOLDER_STRING forge verify-contract ${FEE_DISBURSER_PROXY} Proxy --constructor-args $(shell cast abi-encode "constructor(address)" ${FEE_DISBURSER_DEPLOYER}) --verifier ${VERIFIER} --verifier-url ${VERIFIER_URL} --chain-id ${L2_CHAIN_ID} --num-of-optimizations=99999 --retries=1 --compiler-version v0.8.15+commit.e14f2714 --watch
