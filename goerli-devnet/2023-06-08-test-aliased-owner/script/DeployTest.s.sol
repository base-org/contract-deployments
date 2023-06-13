// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/StdJson.sol";
import "src/TestIncrement.sol";

contract DeployTestIncrement is Script {
    function run(address deployer, address ownerL1) public {
        vm.broadcast(deployer);
        TestIncrement test = new TestIncrement(ownerL1);
        console.log(test.owner());
    }
}