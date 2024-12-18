// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {Script} from "forge-std/Script.sol";

import {DeployFaultDisputeGame} from "./DeployFaultDisputeGame.s.sol";
import {DeployPermissionedDisputeGame} from "./DeployPermissionedDisputeGame.s.sol";

contract DeployHoloceneContracts is Script {
    function run() public {
        DeployFaultDisputeGame deployFaultDisputeGameScript = new DeployFaultDisputeGame();
        DeployPermissionedDisputeGame deployPermissionedDisputeGameScript = new DeployPermissionedDisputeGame();

        vm.startBroadcast();
        deployFaultDisputeGameScript.run();
        deployPermissionedDisputeGameScript.run();
        vm.stopBroadcast();
    }
}
