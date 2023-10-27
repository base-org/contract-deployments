include ../../Makefile
include ../.env
include .env
include ../.env.local


.PHONY: sign
sign:
	$(GOPATH)/bin/eip712sign --private-key $(PRIVATE_KEY) -- \
	forge script --rpc-url $(L2_RPC_URL) UpdateOwners --sig "sign()"

.PHONY: run
run:
	forge script --rpc-url $(L2_RPC_URL) \
	UpdateOwners --sig "run(bytes)" $(SIGNATURES) \
	--private-key $(PRIVATE_KEY) --broadcast
