#!/bin/bash

source .env

if [ -z "$ETHERSCAN_API_KEY" ]; then
  echo "ETHERSCAN_API_KEY is not set. Please set it in .env file"
  exit 1
fi

AnchorStateRegistryProxy="0xfb17A817168BD4DFd48Fb6C9fd07B4409501e3E0"
DelayedWETHProxy="0x9dc3d8500c295e95D5C4EBDeD3222a74fF19e524"
DisputeGameFactoryProxy="0xe545eDE9d1FaDaD12984c31467F56405884b9398"
FaultDisputeGame="0x1E06BAADA3F0a89741B1e9A573d8F8cA9814af01"
PermissionedDisputeGame="0x50406f516C767f903677DD0875217B410F334540"

# function

cast call --rpc-url $SEPOLIA_RPC_URL --chain sepolia --etherscan-api-key $ETHERSCAN_API_KEY $DISPUTE_GAME_FACTORY_PROXY version