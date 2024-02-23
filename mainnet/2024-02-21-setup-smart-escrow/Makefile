include ../../Makefile
include ../.env
include .env

.PHONY: deploy-new-implementations
deploy-new-implementations:
	forge script --rpc-url $(OPTIMISM_RPC_URL) DeploySmartEscrow
