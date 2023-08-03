// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "forge-std/Script.sol";

import "../lib/base-contracts/src/fee-vault-fixes/SequencerFeeVault.sol";
import "../lib/base-contracts/src/fee-vault-fixes/L1FeeVault.sol";
import "../lib/base-contracts/src/fee-vault-fixes/BaseFeeVault.sol";

import { SequencerFeeVault as SequencerFeeVault_Final } from "../lib/optimism/packages/contracts-bedrock/src/L2/SequencerFeeVault.sol";
import { L1FeeVault as L1FeeVault_Final } from "../lib/optimism/packages/contracts-bedrock/src/L2/L1FeeVault.sol";
import { BaseFeeVault as BaseFeeVault_Final } from "../lib/optimism/packages/contracts-bedrock/src/L2/BaseFeeVault.sol";


contract DeployNewFeeVaultsL2 is Script {
    function run(address deployer) public {
        vm.startBroadcast(deployer);

        SequencerFeeVault sfv = new SequencerFeeVault();
        L1FeeVault l1fv = new L1FeeVault();
        BaseFeeVault bfv = new BaseFeeVault();

        SequencerFeeVault_Final sfv_final = new SequencerFeeVault_Final();
        L1FeeVault_Final l1fv_final = new L1FeeVault_Final();
        BaseFeeVault_Final bfv_final = new BaseFeeVault_Final();

        vm.stopBroadcast();

        console.log("Sequencer Fee Vault (Intermediate): %s", address(sfv));
        console.log("L1 Fee Vault (Intermediate): %s", address(l1fv));
        console.log("Base Fee Vault (Intermediate): %s", address(bfv));

        console.log("Sequencer Fee Vault (Final): %s", address(sfv_final));
        console.log("L1 Fee Vault (Final): %s", address(l1fv_final));
        console.log("Base Fee Vault (Final): %s", address(bfv_final));
    }
}
