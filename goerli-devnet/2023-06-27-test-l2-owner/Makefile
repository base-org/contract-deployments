include ../../Makefile
include ../.env
include .env
include ../.env.local

##
# Foundry commands
##
get-impl-addr:
	cast call $(L2_PROXY_ADMIN_CONTRACT) "getProxyImplementation(address)(address)" \
	$(L1_BLOCK_PROXY) --rpc-url $(L2_RPC_URL)

.PHONY: sign
sign:
	forge script --via-ir --rpc-url $(L2_RPC_URL) TestNewOwner \
	--sig "signApproval(address)" $(SAFE_1_ADDR) | \
	grep -A1 vvvvvvvv | grep -v vvvvvvvv | \
	(cd lib/base-contracts && go run ./cmd/sign --private-key $(PRIVATE_KEY))

.PHONY: approve
approve:
	forge script --via-ir --rpc-url $(L2_RPC_URL) TestNewOwner \
	--sig "runApproval(address,bytes)" $(SAFE_1_ADDR) $(SIGNATURES) \
	--private-key $(PRIVATE_KEY) --broadcast

.PHONY: execute
execute:
	forge script --via-ir --rpc-url $(L2_RPC_URL) TestNewOwner \
	--sig "runTransaction(address,bytes)" $(SAFE_2_ADDR) "" \
	--private-key $(PRIVATE_KEY) --broadcast
