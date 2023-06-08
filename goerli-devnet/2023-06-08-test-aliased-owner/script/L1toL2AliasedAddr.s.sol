// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import { AddressAliasHelper } from "@eth-optimism-bedrock/contracts/vendor/AddressAliasHelper.sol";

// TODO: add this to base-org/contracts
contract L1toL2AliasAddress is Script {
    function run(address ownerL1) public view {
        console.log(AddressAliasHelper.applyL1ToL2Alias(ownerL1));
    }
}