include ../../Makefile
include ../.env
include .env

##
# Foundry commands
##
.PHONY: transfer-l1-proxy-admin-owner
transfer-l1-proxy-admin-owner:
	forge script TransferL1ProxyAdminOwner --rpc-url $(L1_RPC_URL) --sig "run()"

.PHONY: transfer-l2-proxy-admin-owner
transfer-l2-proxy-admin-owner:
	forge script TransferL2ProxyAdminOwner --rpc-url $(L2_RPC_URL) --sig "run()"
