// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "src/L1/SystemConfig.sol";
import "forge-std/Script.sol";

contract DeployL1SystemConfig is Script {
    function run() public {
        vm.startBroadcast();
        SystemConfig systemConfigImpl = new SystemConfig();
	console.log("SystemConfig implementation deployed at: ", address(systemConfigImpl));
	vm.stopBroadcast();
    }
}
