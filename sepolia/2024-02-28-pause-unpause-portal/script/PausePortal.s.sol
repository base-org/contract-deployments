// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "forge-std/Script.sol";
import "@eth-optimism-bedrock/src/L1/OptimismPortal.sol";

contract PausePortal is Script {
    address internal OPTIMISM_PORTAL_PROXY = vm.envAddress("OPTIMISM_PORTAL_PROXY");
    address internal GUARDIAN = vm.envAddress("GUARDIAN");

    function run() external {
        vm.startBroadcast(vm.envUint("GUARDIAN_PRIVATE_KEY"));

        OptimismPortal(payable(OPTIMISM_PORTAL_PROXY)).pause();

        vm.stopBroadcast();
    }
}
