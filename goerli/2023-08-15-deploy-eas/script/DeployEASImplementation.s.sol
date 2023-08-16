// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "forge-std/Script.sol";
import "@eas-contracts/ISchemaRegistry.sol";
import "@eas-contracts/SchemaRegistry.sol";
import "@eas-contracts/EAS.sol";

contract DeployEASImplementation is Script {
    address constant internal SCHEMA_REGISTRY_PROXY = 0x4200000000000000000000000000000000000020;

    function run(address deployer) public {
        vm.broadcast(deployer);
        SchemaRegistry schemaRegistry = new SchemaRegistry();
        ISchemaRegistry iSchemaRegistry = ISchemaRegistry(address(SCHEMA_REGISTRY_PROXY));

        vm.broadcast(deployer);
        EAS eas = new EAS(iSchemaRegistry);

        console.logAddress(address(schemaRegistry));
        console.logAddress(address(eas));
    }
}
