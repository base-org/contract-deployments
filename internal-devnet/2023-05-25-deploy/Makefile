include ../../Makefile
include ../.env
include .env

##
# Deploy command
##
.PHONY: deploy
deploy:
	go run cmd/foundry_deploy_config_gen/main.go
	forge script --rpc-url $(L1_RPC_URL) --private-key $(PRIVATE_KEY) DeployBedrock --broadcast
	jq --sort-keys . unsorted.json > deployed/addresses.json
	cp deployed/addresses.json ../addresses.json
	rm unsorted.json inputs/foundry-config.json
