include ../../Makefile
include ../.env
include .env

.PHONY: deploy-new-implementation
deploy-new-implementation:
	forge script --rpc-url $(OPTIMISM_RPC_URL) DeploySmartEscrow
