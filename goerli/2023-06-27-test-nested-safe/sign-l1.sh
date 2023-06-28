#!/bin/bash
set -e

source ../.env
source .env
source .env.local

payload=$(forge script --via-ir --rpc-url ${L1_RPC_URL} TestNestedSafeL1 --sig "signTransaction(address)" ${SIGNER_SAFE_2_L1} | grep -A1 vvvvvvvv | grep -v vvvvvvvv)
cd lib/base-contracts
echo "${payload}" | go run ./cmd/sign --ledger --hd-path "m/44'/60'/${LEDGER_ACCOUNT}'/0/0"
