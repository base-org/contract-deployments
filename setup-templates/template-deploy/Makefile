include ../../Makefile
include ../.env
include .env

##
# Deploy command
##
.PHONY: deploy
deploy:
	chmod +x inputs/construct-config.sh && ./inputs/construct-config.sh && \
	forge script --rpc-url $(L1_RPC_URL) RunDeployBedrock && \
	jq --sort-keys . unsorted.json > deployed/addresses.json && cp deployed/addresses.json ../addresses.json && \
	rm unsorted.json && rm inputs/foundry-config.json
