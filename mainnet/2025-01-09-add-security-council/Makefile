include ../../Makefile
include ../.env
include .env

##
# Foundry commands
##
.PHONY: deploy-new-implementations
deploy-new-implementations:
	forge script --rpc-url $(L2_RPC_URL) DeployNewFeeVaultsL2 --sig "run(address)" $(DEPLOYER)

ifndef LEDGER_ACCOUNT
override LEDGER_ACCOUNT = 0
endif

.PHONY: example-ledger
example-ledger:
	forge script --rpc-url $(RPC_URL) $(script) --sender $(SENDER) --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" --broadcast

##
# MultisigBuilder commands
# The following commands can be used for tasks that utilize the MultisigBuilder.
# Note that --ledger --hd-paths <PATH> can be replaced with --private-key $(PRIVATE_KEY)
# in any command when using a local key.
##

.PHONY: example-sign
example-sign:
	$(GOPATH)/bin/eip712sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" -- \
	forge script --rpc-url $(RPC_URL) $(script) --sig "sign()"

.PHONY: example-run
example-run:
	forge script --rpc-url $(RPC_URL) \
	$(script) --sig "run(bytes)" $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" \
	--broadcast

##
# NestedMultisigBuilder commands
# The following commands can be used for tasks that utilize the NestedMultisigBuilder.
# Note that --ledger --hd-paths <PATH> can be replaced with --private-key $(PRIVATE_KEY)
# in any command when using a local key.
# See more documentation on the various steps in NestedMultisigBuilder.sol.
##

# This step is run by signers on the "children" safes
.PHONY: example-nested-sign
example-nested-sign:
	$(GOPATH)/bin/eip712sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" -- \
	forge script --rpc-url $(RPC_URL) $(script) \
	--sig "sign(address)" $(SIGNER_SAFE_ADDR)

# This step is run once per "child" safe, and can be run by anyone (doesn't have to be a signer)
.PHONY: example-approve
example-approve:
	forge script --rpc-url $(RPC_URL) $(script) \
	--sig "approve(address,bytes)" $(SIGNER_SAFE_ADDR) $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0"

# This step is run once after all children safes have approved and can be run by anyone (doesn't have to be a signer)
.PHONY: example-execute
example-execute:
	forge script --rpc-url $(RPC_URL) $(script) \
	--sig "run()" --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0"