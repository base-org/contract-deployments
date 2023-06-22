include ../../Makefile
include ../.env
include .env

##
# Foundry commands
##
.PHONY: sign
sign:
	chmod +x ./sign.sh && ./sign.sh

.PHONY: run
run:
	forge script --via-ir --rpc-url $(L1_RPC_URL) TransferSystemConfigOwner \
	--sender $(LOCALHOST_ADDR_3) --private-key $(PRIVATE_KEY_3) \
	--sig "run(bytes)" $(SIGNATURES) --broadcast