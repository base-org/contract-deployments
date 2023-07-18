include ../../Makefile
include ../.env
include .env
include ../.env.local

ifndef LEDGER_ACCOUNT
override LEDGER_ACCOUNT = 0
endif

##
# Incident response commands
# Note that --ledger --hd-paths <PATH> can be replaced with --private-key $(PRIVATE_KEY)
# in any command when using a local key.
##

# Delete L2 Outputs Commands

.PHONY: delete-outputs-sign
delete-outputs-sign: deps
	@forge script --via-ir --rpc-url $(L1_RPC_URL) DeleteL2Outputs --sig "sign()" | \
	tee /dev/stderr | grep -A1 vvvvvvvv | grep -v vvvvvvvv | \
	(cd lib/base-contracts && go run ./cmd/sign --private-key $(PRIVATE_KEY))

.PHONY: delete-outputs-run
delete-outputs-run: deps
	@forge script --via-ir --rpc-url $(L1_RPC_URL) \
	DeleteL2Outputs --sig "run(bytes)" $(SIGNATURES) \
	--private-key $(PRIVATE_KEY) \
	--broadcast

# Pause OptimismPortal Commands

.PHONY: pause-portal-sign
pause-portal-sign: deps
	@forge script --via-ir --rpc-url $(L1_RPC_URL) PausePortal --sig "sign()" | \
	tee /dev/stderr | grep -A1 vvvvvvvv | grep -v vvvvvvvv | \
	(cd lib/base-contracts && go run ./cmd/sign --private-key $(PRIVATE_KEY))

.PHONY: pause-portal-run
pause-portal-run: deps
	@forge script --via-ir --rpc-url $(L1_RPC_URL) \
	PausePortal --sig "run(bytes)" $(SIGNATURES) \
	--private-key $(PRIVATE_KEY) \
	--broadcast

# Unpause OptimismPortal Commands

.PHONY: unpause-portal-sign
unpause-portal-sign: deps
	@forge script --via-ir --rpc-url $(L1_RPC_URL) UnpausePortal --sig "sign()" | \
	tee /dev/stderr | grep -A1 vvvvvvvv | grep -v vvvvvvvv | \
	(cd lib/base-contracts && go run ./cmd/sign --private-key $(PRIVATE_KEY))

.PHONY: unpause-portal-run
unpause-portal-run: deps
	@forge script --via-ir --rpc-url $(L1_RPC_URL) \
	UnpausePortal --sig "run(bytes)" $(SIGNATURES) \
	--private-key $(PRIVATE_KEY) \
	--broadcast