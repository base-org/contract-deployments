#!/bin/bash
set -e

source ../.env
source .env
source .env.local

payload=$(forge script --via-ir --rpc-url ${L2_RPC_URL} TestNestedSafeL2 --sig "signApproval(address)" ${SIGNER_SAFE_1_L2} | grep -A1 vvvvvvvv | grep -v vvvvvvvv)
cd lib/base-contracts
echo "${payload}" | go run ./cmd/sign --ledger --hd-path "m/44'/60'/${LEDGER_ACCOUNT}'/0/0"
