include ../../Makefile
include ../.env
include .env

.PHONY: deploy
deploy:
	forge script --rpc-url $(L1_RPC_URL) --private-key $(PRIVATE_KEY) DeploySystemConfig --broadcast

.PHONY: upgrade
upgrade:
	forge script --rpc-url $(L1_RPC_URL) --private-key $(PRIVATE_KEY) UpgradeSystemConfig

.PHONY: set-1559-params
upgrade:
	forge script --rpc-url $(L1_RPC_URL) --private-key $(PRIVATE_KEY) SetEIP1559Params
