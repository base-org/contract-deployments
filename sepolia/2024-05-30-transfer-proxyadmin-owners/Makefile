include ../../Makefile
include ../.env
include .env

##
# Foundry commands
##
.PHONY: transfer-l1-proxy-admin-owner
transfer-l1-proxy-admin-owner:
	forge script TransferL1ProxyAdminOwner --rpc-url $(L1_RPC_URL) --sig "run()" -vvvv

.PHONY: transfer-l2-proxy-admin-owner
transfer-l2-proxy-admin-owner:
	forge script TransferL2ProxyAdminOwner --rpc-url $(L2_RPC_URL) --sig "run()" -vvvv

.PHONY: transfer-system-config-proxy-owner
transfer-system-config-proxy-owner:
	forge script TransferSystemConfigProxyOwner --rpc-url $(L1_RPC_URL) --sig "run()" -vvvv

