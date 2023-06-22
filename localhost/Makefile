##
# Local Environment Setup
##
.PHONY: node
node:
	anvil --init setup/genesis.json

.PHONY: deploy
deploy:
	cd 2023-06-08-deploy && make deps && make deploy-local && make transfer-owner-to-safe && cd ..

