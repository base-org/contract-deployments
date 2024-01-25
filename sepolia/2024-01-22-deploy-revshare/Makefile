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
	forge verify-contract ${BALANCE_TRACKER_IMPL} ./lib/base-contracts/src/revenue-share/BalanceTracker.sol:BalanceTracker --constructor-args $(shell cast abi-encode "constructor(address)" ${PROFIT_WALLET}) --verifier ${VERIFIER} --verifier-url ${L1_VERIFIER_URL}  --chain-id ${BALANCE_TRACKER_CHAIN_ID} --retries=1 --etherscan-api-key ${L1_ETHERSCAN_API_KEY} --optimizer-runs=999999 --watch 
	forge verify-contract ${BALANCE_TRACKER_PROXY} Proxy --constructor-args $(shell cast abi-encode "constructor(address)" ${BALANCE_TRACKER_DEPLOYER}) --verifier ${VERIFIER} --verifier-url ${L1_VERIFIER_URL} --chain-id ${BALANCE_TRACKER_CHAIN_ID} --retries=1 --etherscan-api-key ${L1_ETHERSCAN_API_KEY} --optimizer-runs=999999 --watch 

.PHONY: verify-fee-disburser
verify-fee-disburser:
	ETHERSCAN_API_KEY=$(L2_ETHERSCAN_API_KEY) forge verify-contract ${FEE_DISBURSER_IMPL} ./lib/base-contracts/src/revenue-share/FeeDisburser.sol:FeeDisburser --constructor-args $(shell cast abi-encode "constructor(address,address,uint256)" ${OPTIMISM_WALLET} ${BALANCE_TRACKER_PROXY} ${FEE_DISBURSEMENT_INTERVAL}) --verifier ${VERIFIER} --verifier-url ${L2_VERIFIER_URL} --chain-id ${L2_CHAIN_ID} --optimizer-runs=999999 --retries=1 --compiler-version v0.8.15+commit.e14f2714 --watch 
	ETHERSCAN_API_KEY=$(L2_ETHERSCAN_API_KEY) forge verify-contract ${FEE_DISBURSER_PROXY} Proxy --constructor-args $(shell cast abi-encode "constructor(address)" ${FEE_DISBURSER_DEPLOYER}) --verifier ${VERIFIER} --verifier-url ${L2_VERIFIER_URL} --chain-id ${L2_CHAIN_ID} --num-of-optimizations=99999 --retries=1 --compiler-version v0.8.15+commit.e14f2714 --watch
