#!/bin/bash
set -e

source ../.env
source .env
source .env.local

payload=$(forge script --via-ir --rpc-url ${L2_RPC_URL} TestNestedSafeL2 --sig "signApproval(address)" ${SIGNER_SAFE_1_L2} | tee /dev/stderr | grep -A1 vvvvvvvv | grep -v vvvvvvvv)
cd lib/base-contracts
echo "${payload}" | go run ./cmd/sign --private-key ${PRIVATE_KEY}
