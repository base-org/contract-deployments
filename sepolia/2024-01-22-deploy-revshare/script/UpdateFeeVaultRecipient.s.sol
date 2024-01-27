// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "forge-std/Script.sol";

import "@eth-optimism-bedrock/src/libraries/Predeploys.sol";
import "@eth-optimism-bedrock/src/universal/ProxyAdmin.sol";
import {SequencerFeeVault, FeeVault} from "@eth-optimism-bedrock/src/L2/SequencerFeeVault.sol";
import {L1FeeVault} from "@eth-optimism-bedrock/src/L2/L1FeeVault.sol";
import {BaseFeeVault} from "@eth-optimism-bedrock/src/L2/BaseFeeVault.sol";

contract UpdateFeeVaultRecipient is Script {
    address internal recipient = vm.envAddress("FEE_DISBURSER_PROXY");

    error FeeVaultFailedToUpdate(string feeVaultType, string reason);
    
    function run() public {
        ProxyAdmin proxyAdmin = ProxyAdmin(Predeploys.PROXY_ADMIN);
        address proxyAdminOwner = vm.envAddress("PROXY_ADMIN_OWNER");

        address payable sfvProxy = payable(Predeploys.SEQUENCER_FEE_WALLET);
        address payable lfvProxy = payable(Predeploys.L1_FEE_VAULT);
        address payable bfvProxy = payable(Predeploys.BASE_FEE_VAULT);

        SequencerFeeVault sfvOld = SequencerFeeVault(sfvProxy);
        L1FeeVault lfvOld = L1FeeVault(lfvProxy);
        BaseFeeVault bfvOld = BaseFeeVault(bfvProxy);

        ///
        // CREATE THE NEW FEE VAULTS
        // totalProcessed() should be 0 for existing vaults since no withdraw has done yet
        ///
        vm.startBroadcast(proxyAdminOwner);
        SequencerFeeVault sfvNew = new SequencerFeeVault(
            recipient,
            sfvOld.MIN_WITHDRAWAL_AMOUNT(),
            sfvOld.WITHDRAWAL_NETWORK()
        );
        _checks(sfvOld, sfvNew, "SequencerFeeVault");
        L1FeeVault lfvNew = new L1FeeVault(
            recipient,
            lfvOld.MIN_WITHDRAWAL_AMOUNT(),
            lfvOld.WITHDRAWAL_NETWORK()
        );
        _checks(lfvOld, lfvNew, "L1FeeVault");
        BaseFeeVault bfvNew = new BaseFeeVault(
            recipient,
            bfvOld.MIN_WITHDRAWAL_AMOUNT(),
            bfvOld.WITHDRAWAL_NETWORK()
        );
        _checks(bfvOld, bfvNew, "BaseFeeVault");
        console.log("Sequencer Fee Vault Impl address: %s", address(sfvNew));
        console.log("L1 Fee Vault Impl address: %s", address(lfvNew));
        console.log("Base Fee Vault Impl address: %s", address(bfvNew));

        ///
        // UPDATE THE PROXY IMPLEMENTATIONS
        ///
        proxyAdmin.upgrade(sfvProxy, address(sfvNew));
        require(
            proxyAdmin.getProxyImplementation(sfvProxy).codehash ==
                address(sfvNew).codehash,
            "L1FeeVault not upgraded"
        );
        proxyAdmin.upgrade(lfvProxy, address(lfvNew));
        require(
            proxyAdmin.getProxyImplementation(address(lfvProxy)).codehash ==
                address(lfvNew).codehash,
            "L1FeeVault not upgraded"
        );
        proxyAdmin.upgrade(bfvProxy, address(bfvNew));
        require(
            proxyAdmin.getProxyImplementation(address(bfvProxy)).codehash ==
                address(bfvNew).codehash,
            "BaseFeeVault not upgraded"
        );
        vm.stopBroadcast();
    }

    function _checks(
        FeeVault _oldFV,
        FeeVault _newFV,
        string memory typeOfVault
    ) internal view {
        if (_newFV.totalProcessed() != _oldFV.totalProcessed()) {
            revert FeeVaultFailedToUpdate({
                feeVaultType: typeOfVault,
                reason: "totalProcessed mismatch."
            });
        }
        if (_newFV.MIN_WITHDRAWAL_AMOUNT() != _oldFV.MIN_WITHDRAWAL_AMOUNT()) {
            revert FeeVaultFailedToUpdate({
                feeVaultType: typeOfVault,
                reason: "MIN_WITHDRAWAL_AMOUNT mismatch."
            });
        }
        if (_newFV.WITHDRAWAL_NETWORK() != _oldFV.WITHDRAWAL_NETWORK()) {
            revert FeeVaultFailedToUpdate({
                feeVaultType: typeOfVault,
                reason: "WITHDRAWAL_NETWORK mismatch."
            });
        }
        if (_newFV.RECIPIENT() != recipient) {
            revert FeeVaultFailedToUpdate({
                feeVaultType: typeOfVault,
                reason: "incorrect new recipient."
            });
        }
    }
}
