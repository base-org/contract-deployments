include ../../Makefile
include ../.env
include .env

##
# Deploy command
##
.PHONY: deploy
deploy:
	./inputs/construct-config.sh && \
	forge script --rpc-url $(L1_RPC_URL) --private-key $(PRIVATE_KEY) DeployBedrock --broadcast
	jq --sort-keys . unsorted.json > deployed/addresses.json
	cp deployed/addresses.json ../addresses.json
	rm unsorted.json inputs/foundry-config.json
