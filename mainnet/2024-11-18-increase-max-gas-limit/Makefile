include ../../Makefile
include ../.env
include .env

ifndef LEDGER_ACCOUNT
override LEDGER_ACCOUNT = 0
endif

# Overwriting this from top level makefile to change the branch
.PHONY: checkout-op-commit
checkout-op-commit:
	rm -rf lib/optimism
	mkdir -p lib/optimism
	cd lib/optimism; \
	git init; \
	git remote add origin $(OPTIMISM_REPO); \
	git fetch --depth=1 origin $(OPTIMISM_PR_ID):pr_branch; \
	git switch pr_branch


.PHONY: deploy
deploy:
	$(GOPATH)/bin/eip712sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" -- \
	forge script --rpc-url $(L1_RPC_URL) DeploySystemConfig --sig "sign(address)"

.PHONY: sign
sign:
	$(GOPATH)/bin/eip712sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" -- \
	forge script --rpc-url $(L1_RPC_URL) UpgradeSystemConfig \
	--sig "sign()"

.PHONY: run-upgrade
run-upgrade:
	forge script --rpc-url $(L1_RPC_URL) UpgradeSystemConfig \
	--sig "run(bytes)" $(SIGNATURES) -i 1 --broadcast
