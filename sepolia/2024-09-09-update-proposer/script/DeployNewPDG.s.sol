// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {PermissionedDisputeGame} from "@eth-optimism-bedrock/src/dispute/PermissionedDisputeGame.sol";
import "forge-std/Script.sol";

contract DeployNewPDG is Script {
    address internal NEW_PROPOSER = vm.envAddress("NEW_PROPOSER");
    address internal PERMISSIONED_DISPUTE_GAME = vm.envAddress("PERMISSIONED_DISPUTE_GAME");
    address internal DISPUTE_GAME_FACTORY_PROXY_OWNER = vm.envAddress("DISPUTE_GAME_FACTORY_PROXY_OWNER");

    function run() public {
        PermissionedDisputeGame pdg = PermissionedDisputeGame(PERMISSIONED_DISPUTE_GAME);
        // vm.broadcast(DISPUTE_GAME_FACTORY_PROXY_OWNER);
        PermissionedDisputeGame newPdgImpl = new PermissionedDisputeGame({
            _gameType: pdg.gameType(),
            _absolutePrestate: pdg.absolutePrestate(),
            _maxGameDepth: pdg.maxGameDepth(),
            _splitDepth: pdg.splitDepth(),
            _clockExtension: pdg.clockExtension(),
            _maxClockDuration: pdg.maxClockDuration(),
            _vm: pdg.vm(),
            _weth: pdg.weth(),
            _anchorStateRegistry: pdg.anchorStateRegistry(),
            _l2ChainId: pdg.l2ChainId(),
            _proposer: NEW_PROPOSER,
            _challenger: pdg.challenger()
        });
        require(newPdgImpl.proposer() == NEW_PROPOSER, "Deploy: proposer is incorrect");
        console.log("New permissioned dispute game address: ", address(newPdgImpl));
        console.log("New proposer: ", newPdgImpl.proposer());
    }
}