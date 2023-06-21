#!/bin/bash
set -e

source ../.env
source .env

payload=$(forge script --via-ir --rpc-url ${L1_RPC_URL} TransferSystemConfigOwner --sender ${LOCALHOST_ADDR_1} --private-key ${PRIVATE_KEY} --sig "sign()" | grep -A1 vvvvvvvv | grep -v vvvvvvvv)
cd lib/base-contracts
echo "${payload}" | go run ./cmd/sign --private-key ${PRIVATE_KEY}
