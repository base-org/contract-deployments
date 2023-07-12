include ../../Makefile
include ../.env
include .env

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
delete-outputs-sign:
	forge script --via-ir --rpc-url $(L1_RPC_URL) DeleteL2Outputs --sig "sign()" | \
	grep -A1 vvvvvvvv | grep -v vvvvvvvv | \
	(cd lib/base-contracts && go run ./cmd/sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0")

.PHONY: delete-outputs-run
delete-outputs-run:
	forge script --via-ir --rpc-url $(L1_RPC_URL) \
	DeleteL2Outputs --sig "run(bytes)" $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" \
	--broadcast

# Pause OptimismPortal Commands

.PHONY: pause-portal-sign
pause-portal-sign:
	forge script --via-ir --rpc-url $(L1_RPC_URL) PausePortal --sig "sign()" | \
	grep -A1 vvvvvvvv | grep -v vvvvvvvv | \
	(cd lib/base-contracts && go run ./cmd/sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0")

.PHONY: pause-portal-run
pause-portal-run:
	forge script --via-ir --rpc-url $(L1_RPC_URL) \
	PausePortal --sig "run(bytes)" $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" \
	--broadcast

# Unpause OptimismPortal Commands

.PHONY: unpause-portal-sign
unpause-portal-sign:
	forge script --via-ir --rpc-url $(L1_RPC_URL) UnpausePortal --sig "sign()" | \
	grep -A1 vvvvvvvv | grep -v vvvvvvvv | \
	(cd lib/base-contracts && go run ./cmd/sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0")

.PHONY: unpause-portal-run
unpause-portal-run:
	forge script --via-ir --rpc-url $(L1_RPC_URL) \
	UnpausePortal --sig "run(bytes)" $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" \
	--broadcast