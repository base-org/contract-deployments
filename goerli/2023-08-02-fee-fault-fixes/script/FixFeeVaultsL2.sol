// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "../lib/base-contracts/script/universal/NestedMultisigBuilder.sol";
import "../lib/optimism/packages/contracts-bedrock/src/libraries/Predeploys.sol"; // TODO: clean up w/ `@eth-optimism-bedrock` prefix

// import { console } from "forge-std/console.sol";
import { IMulticall3 } from "forge-std/interfaces/IMulticall3.sol";

// import { IGnosisSafe, Enum } from "@eth-optimism-bedrock/scripts/interfaces/IGnosisSafe.sol";

import "../lib/base-contracts/src/fee-vault-fixes/FeeVault.sol";

/**
 * @title FixFeeVaultsL2
 * @notice TODO
 */
contract FixFeeVaultsL2 is NestedMultisigBuilder {
    ProxyAdmin PROXY_ADMIN = PROXY_ADMIN(Predeploys.PROXY_ADMIN);

    address constant internal SequencerFeeVault = Predeploys.SEQUENCER_FEE_WALLET;
    address constant internal L1FeeVault = Predeploys.L1_FEE_VAULT;
    address constant internal BaseFeeVault = Predeploys.BASE_FEE_VAULT;

    address constant internal SequencerFeeVaultImpl_1; // TODO
    address constant internal L1FeeVaultImpl_1; // TODO
    address constant internal BaseFeeVaultImpl_1; // TODO

    address constant internal SequencerFeeVaultImpl_Final; // TODO
    address constant internal L1FeeVaultImpl_Final; // TODO
    address constant internal BaseFeeVaultImpl_Final; // TODO

    address constant internal L2_NESTED_SAFE = 0x2304cb33d95999dc29f4cef1e35065e670a70050; // TODO


    function _buildCalls() internal override view returns (IMulticall3.Call3[] memory) {

        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](6);

        bytes memory setTotalProcessed = abi.encodeCall(
            FeeVault.setTotalProcessed, (/* TODO: calculate int or look up on Etherscan */)
        );

        // for each vault:
        //  1. upgradeAndCall to intermediate implementation
        //  2. upgrade to final implementation (w/ init as necessary)

        calls[0] = IMulticall3.Call3({
            target: PROXY_ADMIN,
            allowFailure: false,
            callData: abi.encodeCall(
                PROXY_ADMIN.upgradeAndCall,
                (
                    SequencerFeeVault,
                    SequencerFeeVaultImpl_1,
                    setTotalProcessed
                )
            )
        });

        calls[1] = IMulticall3.Call3({
            target: PROXY_ADMIN,
            allowFailure: false,
            callData: abi.encodeCall(
                PROXY_ADMIN.upgrade,
                (
                    SequencerFeeVault,
                    SequencerFeeVaultImpl_Final
                )
            )
        });

        calls[2] = IMulticall3.Call3({
            target: PROXY_ADMIN,
            allowFailure: false,
            callData: abi.encodeCall(
                PROXY_ADMIN.upgradeAndCall,
                (
                    L1FeeVault,
                    L1FeeVaultImpl_1,
                    setTotalProcessed
                )
            )
        });

        calls[3] = IMulticall3.Call3({
            target: PROXY_ADMIN,
            allowFailure: false,
            callData: abi.encodeCall(
                PROXY_ADMIN.upgrade,
                (
                    L1FeeVault,
                    L1FeeVaultImpl_Final
                )
            )
        });

        calls[4] = IMulticall3.Call3({
            target: PROXY_ADMIN,
            allowFailure: false,
            callData: abi.encodeCall(
                PROXY_ADMIN.upgradeAndCall,
                (
                    BaseFeeVault,
                    BaseFeeVaultImpl_1,
                    setTotalProcessed
                )
            )
        });

        calls[5] = IMulticall3.Call3({
            target: PROXY_ADMIN,
            allowFailure: false,
            callData: abi.encodeCall(
                PROXY_ADMIN.upgrade,
                (
                    BaseFeeVault,
                    BaseFeeVaultImpl_Final
                )
            )
        });

        return calls;
    }

    function _ownerSafe() internal override view returns (address) {
        return L2_NESTED_SAFE;
    }

    function _postCheck() internal override view {
         require(
            proxyAdmin.getProxyImplementation(SequencerFeeVault).codehash == SequencerFeeVaultImpl_Final.codehash,
            "FixFeeVaultsL2: SequencerFeeVault not upgraded"
        );


        require(
            proxyAdmin.getProxyImplementation(L1FeeVault).codehash == L1FeeVaultImpl_Final.codehash,
            "FixFeeVaultsL2: L1FeeVault not upgraded"
        );

        require(
            proxyAdmin.getProxyImplementation(BaseFeeVault).codehash == BaseFeeVaultImpl_Final.codehash,
            "FixFeeVaultsL2: BaseFeeVault not upgraded"
        );
    }
}
