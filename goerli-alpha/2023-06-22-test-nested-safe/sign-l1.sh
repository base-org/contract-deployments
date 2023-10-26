#!/bin/bash
set -e

source ../.env
source .env
source .env.local

payload=$(forge script --via-ir --rpc-url ${L1_RPC_URL} TestNestedSafeL1 --sig "signTransaction(address)" ${SIGNER_SAFE_2_L1} | tee /dev/stderr | grep -A1 vvvvvvvv | grep -v vvvvvvvv)
cd lib/base-contracts
echo "${payload}" | go run ./cmd/sign --private-key ${PRIVATE_KEY}

