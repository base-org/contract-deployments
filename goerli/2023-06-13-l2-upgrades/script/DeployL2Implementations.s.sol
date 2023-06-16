// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/StdJson.sol";
import "@base-contracts/script/deploy/l2/DeployBedrockL2ImplContracts.s.sol";

contract DeployL2Implementations is Script {
    function run() public {
        DeployBedrockL2ImplContracts deployL2 = new DeployBedrockL2ImplContracts();
        deployL2.run();
    }
}
