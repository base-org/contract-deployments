// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "forge-std/Script.sol";

import "@eth-optimism-bedrock/src/dispute/AnchorStateRegistry.sol";

contract VerifyContractState is Script {
    function setUp() public {}

    function run() public {
        verifyAnchorStateRegistry();
        verifyDelayedWETH();
        verifyDisputeGameFactory();
        verifyFaultDisputeGame();
        verifyPermissionedDisputeGame();
    }

    function verifyAnchorStateRegistry() internal returns (bool) {
        // TODO: Implement
    }
    function verifyDelayedWETH() internal returns (bool) {
        // TODO: Implement
    }
    function verifyDisputeGameFactory() internal returns (bool) {
        // TODO: Implement
    }
    function verifyFaultDisputeGame() internal returns (bool) {
        // TODO: Implement
    }
    function verifyPermissionedDisputeGame() internal returns (bool) {
        // TODO: Implement
    }
}
