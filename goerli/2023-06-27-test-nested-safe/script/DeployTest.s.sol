// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "forge-std/Script.sol";
import "@base-contracts/src/TestOwner.sol";

contract DeployTest is Script {
    function run(address deployer, address nestedSafe) public {
        vm.broadcast(deployer);
        TestOwner testowner = new TestOwner(nestedSafe);
        console.log(address(testowner));
    }
}
