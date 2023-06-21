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
	--sender $(LOCALHOST_ADDR_2) --private-key $(PRIVATE_KEY_2) \
	--sig "run(bytes)" $(SIGNATURES) --broadcast