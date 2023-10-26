include ../../Makefile
include ../.env
include .env

##
# Foundry commands
##
get-aliased-addr:
	forge script L1toL2AliasAddress --sig "run(address)" $(OWNER_L1)

deploy-test-increment:
	forge script --rpc-url $(L2_RPC_URL) DeployTestIncrement --private-key $(PRIVATE_KEY) --sig "run(address,address)" $(DEPLOYER) $(OWNER_L2_ALIAS) --broadcast

call-increment:
	forge script -vvvv --rpc-url $(L1_RPC_URL) SafeForcedInclusion --sender $(SENDER) --private-key $(SIGNER_PRIVATE_KEY) --sig "run(address)" $(OWNER_L1)