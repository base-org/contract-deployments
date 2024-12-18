// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {Script} from "forge-std/Script.sol";

import {
    FaultDisputeGame,
    IAnchorStateRegistry,
    IDelayedWETH,
    IBigStepper
} from "@eth-optimism-bedrock/src/dispute/FaultDisputeGame.sol";
import {GameTypes, Duration, Claim} from "@eth-optimism-bedrock/src/dispute/lib/Types.sol";

contract DeployFaultDisputeGame is Script {
    uint256 maxGameDepth = vm.envUint("MAX_GAME_DEPTH");
    uint256 splitDepth = vm.envUint("SPLIT_DEPTH");
    uint256 l2ChainId = vm.envUint("L2_CHAIN_ID");
    Duration clockExtension = Duration.wrap(uint64(vm.envUint("CLOCK_EXTENSION")));
    Duration maxClockDuration = Duration.wrap(uint64(vm.envUint("MAX_CLOCK_DURATION")));

    IAnchorStateRegistry anchorStateRegistry =
        IAnchorStateRegistry(payable(vm.envAddress("ANCHOR_STATE_REGISTRY_ADDRESS")));
    IDelayedWETH weth = IDelayedWETH(payable(vm.envAddress("WETH_ADDRESS")));
    IBigStepper bigStepper = IBigStepper(payable(vm.envAddress("BIG_STEPPER_ADDRESS")));

    function run() public {
        FaultDisputeGame.GameConstructorParams memory params = FaultDisputeGame.GameConstructorParams({
            gameType: GameTypes.CANNON,
            absolutePrestate: Claim.wrap(vm.envBytes32("ABSOLUTE_PRESTATE")),
            maxGameDepth: maxGameDepth,
            splitDepth: splitDepth,
            clockExtension: clockExtension,
            maxClockDuration: maxClockDuration,
            vm: bigStepper,
            weth: weth,
            anchorStateRegistry: anchorStateRegistry,
            l2ChainId: l2ChainId
        });

        new FaultDisputeGame(params);
    }
}
