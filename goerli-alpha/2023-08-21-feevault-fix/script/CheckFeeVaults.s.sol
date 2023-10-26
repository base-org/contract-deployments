// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "forge-std/Script.sol";

import { FeeVault } from "@eth-optimism-bedrock/src/universal/FeeVault.sol";
import { Predeploys } from "@eth-optimism-bedrock/src/libraries/Predeploys.sol";

contract CheckFeeVaults is Script {

    function run(address payable recipient, uint256 minimumWithdrawalAmount, uint8 withdrawalNetwork, uint256 totalProcessed) external {
        address[3] memory feeVaults = [
            Predeploys.SEQUENCER_FEE_WALLET,
            Predeploys.L1_FEE_VAULT,
            Predeploys.BASE_FEE_VAULT
        ];

        for (uint256 i; i < feeVaults.length; i++) {
            FeeVault feeVault = FeeVault(payable(feeVaults[i]));
            require(feeVault.RECIPIENT() == recipient, "CheckFeeVaults: recipient incorrect");
            require(feeVault.MIN_WITHDRAWAL_AMOUNT() == minimumWithdrawalAmount, "CheckFeeVaults: minimum withdrawal amount incorrect");
            require(uint8(feeVault.WITHDRAWAL_NETWORK()) == withdrawalNetwork, "CheckFeeVaults: withdrawal network incorrect");
            require(feeVault.totalProcessed() == totalProcessed, "CheckFeeVaults: total processed incorrect");
        }
        console.log("Fee vault checks passed!");
    }
}

