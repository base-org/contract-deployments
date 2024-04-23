include ../../Makefile
include ../.env
include .env

ifndef LEDGER_ACCOUNT
override LEDGER_ACCOUNT = 0
endif

### L1 migration commands

.PHONY: sign-cb-l1
sign-cb-l1:
	$(GOPATH)/bin/eip712sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" -- \
	forge script --rpc-url $(L1_RPC_URL) MigrateL1ToSecurityCouncil \
	--sig "sign(address)" $(L1_BASE_SAFE)

.PHONY: sign-op-l1
sign-op-l1:
	$(GOPATH)/bin/eip712sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" -- \
	forge script --rpc-url $(L1_RPC_URL) MigrateL1ToSecurityCouncil \
	--sig "sign(address)" $(L1_OP_SAFE)


.PHONY: approve-cb-l1
approve-cb-l1:
	forge script --rpc-url $(L1_RPC_URL) MigrateL1ToSecurityCouncil \
	--sig "approve(address,bytes)" $(L1_BASE_SAFE) $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0"

.PHONY: approve-op-l1
approve-op-l1:
	forge script --rpc-url $(L1_RPC_URL) MigrateL1ToSecurityCouncil \
	--sig "approve(address,bytes)" $(L1_OP_SAFE) $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0"

.PHONY: execute-l1
execute-l1:
	forge script --rpc-url $(L1_RPC_URL) MigrateL1ToSecurityCouncil \
	--sig "run()" --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0"

### L2 migration commands

.PHONY: sign-cb-l2
sign-cb-l2:
	$(GOPATH)/bin/eip712sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" -- \
	forge script --rpc-url $(L2_RPC_URL) MigrateL2ToSecurityCouncil \
	--sig "sign(address)" $(L2_BASE_SAFE)

.PHONY: sign-op-l2
sign-op-l2:
	$(GOPATH)/bin/eip712sign --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0" -- \
	forge script --rpc-url $(L2_RPC_URL) MigrateL2ToSecurityCouncil \
	--sig "sign(address)" $(L2_OP_SAFE)


.PHONY: approve-cb-l2
approve-cb-l2:
	forge script --rpc-url $(L2_RPC_URL) MigrateL2ToSecurityCouncil \
	--sig "approve(address,bytes)" $(L2_BASE_SAFE) $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0"

.PHONY: approve-op-l2
approve-op-l2:
	forge script --rpc-url $(L2_RPC_URL) MigrateL2ToSecurityCouncil \
	--sig "approve(address,bytes)" $(L2_OP_SAFE) $(SIGNATURES) \
	--ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0"

.PHONY: execute-l2
execute-l2:
	forge script --rpc-url $(L2_RPC_URL) MigrateL2ToSecurityCouncil \
	--sig "run()" --ledger --hd-paths "m/44'/60'/$(LEDGER_ACCOUNT)'/0/0"
