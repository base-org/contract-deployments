// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "forge-std/Script.sol";
import "@eth-optimism-bedrock/src/EAS/EAS.sol";
import "@eth-optimism-bedrock/src/EAS/SchemaRegistry.sol";

contract DeployUpgradedEAS is Script {
    address internal _deployer = vm.envAddress("DEPLOYER");

    function run() public {
        vm.broadcast(_deployer);
        SchemaRegistry schemaRegistry = new SchemaRegistry();

        vm.broadcast(_deployer);
        EAS eas = new EAS();

        console.logAddress(_deployer);
        console.logAddress(address(schemaRegistry));
        console.logAddress(address(eas));
    }
}
