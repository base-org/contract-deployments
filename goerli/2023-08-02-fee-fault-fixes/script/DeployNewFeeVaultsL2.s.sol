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
        vm.broadcast(deployer);

        SequencerFeeVault sfv = new SequencerFeeVault();
        L1FeeVault l1fv = new L1FeeVault();
        BaseFeeVault bfv = new BaseFeeVault();

        // TODO: other

        SequencerFeeVault sfv_final = new SequencerFeeVault_Final();
        L1FeeVault l1fv_final = new L1FeeVault_Final();
        BaseFeeVault bfv_final = new BaseFeeVault_Final();

        console.log(address(sfv));
        console.log(address(l1fv));
        console.log(address(bfv));

        console.log(address(sfv_final));
        console.log(address(l1fv_final));
        console.log(address(bfv_final));
    }
}
