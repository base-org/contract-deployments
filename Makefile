PROJECT_DIR = $(network)/$(shell date +'%Y-%m-%d')-$(task)
DEPLOY_DIR = $(network)/$(shell date +'%Y-%m-%d')-deploy
TEMPLATE_GENERIC = setup-templates/template-generic
TEMPLATE_DEPLOY = setup-templates/template-deploy

##
# Project Setup
##
# Run `make setup-task network=<network> task=<task>`
setup-task:
	rm -rf $(TEMPLATE_GENERIC)/cache $(TEMPLATE_GENERIC)/lib $(TEMPLATE_GENERIC)/out
	cp -r $(TEMPLATE_GENERIC) $(PROJECT_DIR)

# Run `make setup-deploy network=<network>`
setup-deploy:
	rm -rf $(TEMPLATE_DEPLOY)/cache $(TEMPLATE_DEPLOY)/lib $(TEMPLATE_DEPLOY)/out
	mkdir -p $(network) && cp -r $(TEMPLATE_DEPLOY) $(DEPLOY_DIR)

##
# Solidity Setup
##
.PHONY: deps
deps: clean-lib forge-deps checkout-op-commit checkout-base-contracts-commit

.PHONY: clean-lib
clean-lib:
	rm -rf lib

.PHONY: forge-deps
forge-deps:
	forge install --no-git github.com/foundry-rs/forge-std \
		github.com/OpenZeppelin/openzeppelin-contracts@v4.7.3 \
		github.com/OpenZeppelin/openzeppelin-contracts-upgradeable@v4.7.3 \
		github.com/rari-capital/solmate@8f9b23f8838670afda0fd8983f2c41e8037ae6bc

.PHONY: checkout-op-commit
checkout-op-commit:
	[ -n "$(OP_COMMIT)" ] || (echo "OP_COMMIT must be set in .env" && exit 1)
	rm -rf lib/optimism
	mkdir -p lib/optimism
	cd lib/optimism; \
	git init; \
	git remote add origin https://github.com/ethereum-optimism/optimism.git; \
	git fetch --depth=1 origin $(OP_COMMIT); \
	git reset --hard FETCH_HEAD

.PHONY: checkout-base-contracts-commit
checkout-base-contracts-commit:
	[ -n "$(BASE_CONTRACTS_COMMIT)" ] || (echo "BASE_CONTRACTS_COMMIT must be set in .env" && exit 1)
	chmod 600 ../../tmp/tmpsshkey
	rm -rf lib/base-contracts
	mkdir -p lib/base-contracts
	eval `ssh-agent`; \
	ssh-add ../../tmp/tmpsshkey; \
	cd lib/base-contracts; \
	git init; \
	git remote add origin git@github.com:base-org/contracts.git; \
	git fetch --depth=1 origin $(BASE_CONTRACTS_COMMIT); \
	git reset --hard FETCH_HEAD

##
# Solidity Testing
##
.PHONY: solidity-test
solidity-test:
	forge test --ffi -vvv
