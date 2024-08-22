// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {SystemConfig} from "@eth-optimism-bedrock/src/L1/SystemConfig.sol";
import { Vm } from "forge-std/Vm.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract UpdateBatcherHash is Script {
    address internal SYSTEM_CONFIG_OWNER = vm.envAddress("SYSTEM_CONFIG_OWNER");
    address internal L1_SYSTEM_CONFIG = vm.envAddress("L1_SYSTEM_CONFIG_ADDRESS");
    bytes32 internal NEW_BATCH_SENDER = bytes32(vm.envBytes32("NEW_BATCH_SENDER"));

    function run() public {
        console.log("Current batcherHash: ");
        console.logBytes32(SystemConfig(L1_SYSTEM_CONFIG).batcherHash());
        // Update
        SystemConfig(L1_SYSTEM_CONFIG).setBatcherHash(NEW_BATCH_SENDER);
        console.log("New batcherHash: ");
        console.logBytes32(SystemConfig(L1_SYSTEM_CONFIG).batcherHash());
        assert(SystemConfig(L1_SYSTEM_CONFIG).batcherHash() == NEW_BATCH_SENDER);
    }
}
