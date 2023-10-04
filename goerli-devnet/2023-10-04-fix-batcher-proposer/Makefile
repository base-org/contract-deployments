include ../../Makefile
include ../.env
include .env

##
# Foundry commands
##

.PHONY: sign
sign:
	$(GOPATH)/bin/eip712sign --private-key $(PRIVATE_KEY) -- \
	forge script --rpc-url $(L1_RPC_URL) SetBatcherAddr --sig "sign()"

.PHONY: run
run:
	forge script --rpc-url $(L1_RPC_URL) \
	SetBatcherAddr --sig "run(bytes)" $(SIGNATURES) \
	--private-key $(PRIVATE_KEY) \
	--broadcast