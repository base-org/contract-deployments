// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "forge-std/Script.sol";
import "@base-contracts/src/smart-escrow/SmartEscrow.sol";

contract DeploySmartEscrow is Script {
    address internal DEPLOYER = vm.envAddress("DEPLOYER");
    address internal BENEFACTOR = vm.envAddress("BENEFACTOR");
    address internal BENEFICIARY = vm.envAddress("BENEFICIARY");
    address internal BENEFACTOR_OWNER = vm.envAddress("BENEFACTOR_OWNER");
    address internal BENEFICIARY_OWNER = vm.envAddress("BENEFICIARY_OWNER");
    address internal ESCROW_OWNER = vm.envAddress("NESTED_SAFE");
    uint256 internal START = vm.envUint256("START");
    uint256 internal END = vm.envUint256("END");
    uint256 internal VESTING_PERIOD_SECONDS = vm.envUint256("VESTING_PERIOD_SECONDS");
    uint256 internal INITIAL_TOKENS = vm.envUint256("INITIAL_TOKENS");
    uint256 internal VESTING_EVENT_TOKENS = vm.envUint256("VESTING_EVENT_TOKENS");

    function run() public {
        vm.broadcast(deployer);
        SmartEscrow smartEscrow = new SmartEscrow(
            BENEFACTOR,
            BENEFICIARY,
            BENEFACTOR_OWNER,
            BENEFICIARY_OWNER,
            ESCROW_OWNER,
            START,
            END,
            VESTING_PERIOD_SECONDS,
            INITIAL_TOKENS,
            VESTING_EVENT_TOKENS
        );
        require(smartEscrow.start() = START);
        require(smartEscrow.end() = END);
        require(smartEscrow.vestingPeriod() = VESTING_PERIOD_SECONDS);
        require(smartEscrow.initialTokens() = INITIAL_TOKENS);
        require(smartEscrow.vestingEventTokens() = VESTING_EVENT_TOKENS);
        require(smartEscrow.benefactor() = BENEFATOR); 
        require(smartEscrow.beneficiary() = BENEFICIARY);
        require(smartEscrow.released() = 0);
        require(smartEscrow.contractTerminated() = false);
    }
}
