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

# Pause OptimismPortal Commands

.PHONY: pause-portal
pause-portal: deps
	forge script --rpc-url $(L1_RPC_URL) \
	PausePortal --private-key $(GUARDIAN_PRIVATE_KEY) \
	--broadcast

# Unpause OptimismPortal Commands

.PHONY: unpause-portal
unpause-portal: deps
	forge script --rpc-url $(L1_RPC_URL) \
	UnpausePortal --private-key $(GUARDIAN_PRIVATE_KEY) \
	--broadcast
