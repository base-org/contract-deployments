include ../../Makefile
include ../.env
include .env

##
# Foundry commands
##
.PHONY: deploy-eas
deploy-eas:
	forge script --rpc-url $(L2_RPC_URL) DeployUpgradedEAS

.PHONY: deploy-token-factory
deploy-token-factory:
	forge script --rpc-url $(L2_RPC_URL) DeployUpgradedTokenFactory

verify-eas-implementations:
	forge verify-contract ${REGISTRY_IMPL_ADDRESS} ./lib/optimism/packages/contracts-bedrock/src/EAS/SchemaRegistry.sol:SchemaRegistry --verifier ${VERIFIER} --watch --chain-id $(L2_CHAIN_ID)  --verifier-url ${VERIFIER_URL} --compiler-version v0.8.15+commit.e14f2714 --num-of-optimizations=99999 --retries=1
	forge verify-contract ${EAS_IMPL_ADDRESS} ./lib/optimism/packages/contracts-bedrock/src/EAS/EAS.sol:EAS --verifier ${VERIFIER} --watch --chain-id $(L2_CHAIN_ID)  --verifier-url ${VERIFIER_URL} --compiler-version v0.8.15+commit.e14f2714 --num-of-optimizations=99999 --retries=1

verify-token-factory:
	forge verify-contract ${ERC20_IMPL_ADDRESS} ./lib/optimism/packages/contracts-bedrock/src/universal/OptimismMintableERC20Factory.sol:OptimismMintableERC20Factory --verifier ${VERIFIER} --watch --chain-id $(L2_CHAIN_ID)  --verifier-url ${VERIFIER_URL} --compiler-version v0.8.15+commit.e14f2714 --num-of-optimizations=99999 --retries=1
	forge verify-contract ${ERC721_IMPL_ADDRESS} ./lib/optimism/packages/contracts-bedrock/src/universal/OptimismMintableERC721Factory.sol:OptimismMintableERC721Factory --verifier ${VERIFIER} --watch --chain-id $(L2_CHAIN_ID)  --verifier-url ${VERIFIER_URL} --compiler-version v0.8.15+commit.e14f2714 --num-of-optimizations=99999 --retries=1

##
# Commands for signers to run to test the nested safe
##

.PHONY: sign-op
sign-op:
	$(GOPATH)/bin/eip712sign --private-key ${PRIVATE_KEY} -- \
	forge script --rpc-url $(L2_RPC_URL) UpgradeToEAS \
	--sig "sign(address)" $(OP_SAFE_ADDR)

.PHONY: sign-cb
sign-cb:
	$(GOPATH)/bin/eip712sign --private-key ${PRIVATE_KEY} -- \
	forge script --via-ir --rpc-url $(L2_RPC_URL) UpgradeToEAS \
	--sig "sign(address)" $(CB_SAFE_ADDR)

##
# Commands for faciliators to run to test the nested safe
##

.PHONY: approve-op
approve-op:
	forge script --rpc-url $(L2_RPC_URL) UpgradeToEAS \
	--sig "approve(address,bytes)" $(OP_SAFE_ADDR) $(SIGNATURES) \
	--private-key ${PRIVATE_KEY} --broadcast

.PHONY: approve-cb
approve-cb:
	forge script --rpc-url $(L2_RPC_URL) UpgradeToEAS \
	--sig "approve(address,bytes)" $(CB_SAFE_ADDR) $(SIGNATURES) \
	--private-key ${PRIVATE_KEY} --broadcast

execute:
	forge script --rpc-url $(L2_RPC_URL) UpgradeToEAS \
	--sig "run()" --private-key ${PRIVATE_KEY} --broadcast


# TODO: verify-eas
# ifndef LEDGER_ACCOUNT
# override LEDGER_ACCOUNT = 0
# endif

# .PHONY: example-ledger
# example-ledger:
# 	forge script --rpc-url $(RPC_URL) $(script) --sender $(SENDER) --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" --broadcast

# ##
# # MultisigBuilder commands
# # The following commands can be used for tasks that utilize the MultisigBuilder.
# # Note that --ledger --hd-paths <PATH> can be replaced with --private-key $(PRIVATE_KEY)
# # in any command when using a local key.
# ##

# .PHONY: example-sign
# example-sign:
# 	$(GOPATH)/bin/eip712sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" -- \
# 	forge script --rpc-url $(RPC_URL) $(script) --sig "sign()"

# .PHONY: example-run
# example-run:
# 	forge script --rpc-url $(RPC_URL) \
# 	$(script) --sig "run(bytes)" $(SIGNATURES) \
# 	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" \
# 	--broadcast

# ##
# # NestedMultisigBuilder commands
# # The following commands can be used for tasks that utilize the NestedMultisigBuilder.
# # Note that --ledger --hd-paths <PATH> can be replaced with --private-key $(PRIVATE_KEY)
# # in any command when using a local key.
# # See more documentation on the various steps in NestedMultisigBuilder.sol.
# ##

# # This step is run by signers on the "children" safes
# .PHONY: example-nested-sign
# example-nested-sign:
# 	$(GOPATH)/bin/eip712sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" -- \
# 	forge script --rpc-url $(RPC_URL) $(script) \
# 	--sig "sign(address)" $(SIGNER_SAFE_ADDR)

# # This step is run once per "child" safe, and can be run by anyone (doesn't have to be a signer)
# .PHONY: example-approve
# example-approve:
# 	forge script --rpc-url $(RPC_URL) $(script) \
# 	--sig "approve(address,bytes)" $(SIGNER_SAFE_ADDR) $(SIGNATURES) \
# 	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0"

# # This step is run once after all children safes have approved and can be run by anyone (doesn't have to be a signer)
# .PHONY: example-execute
# example-execute:
# 	forge script --rpc-url $(RPC_URL) $(script) \
# 	--sig "run()" --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0"