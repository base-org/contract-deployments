// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

// import "../lib/base-contracts/script/universal/NestedMultisigBuilder.sol";
// import "@eth-optimism-bedrock/src/libraries/Predeploys.sol";

// import { IMulticall3 } from "forge-std/interfaces/IMulticall3.sol";
// import "@eth-optimism-bedrock/src/universal/ProxyAdmin.sol";

// import { SequencerFeeVault as SequencerFeeVault_Final } from "@eth-optimism-bedrock/src/L2/SequencerFeeVault.sol";
// import { L1FeeVault as L1FeeVault_Final } from "@eth-optimism-bedrock/src/L2/L1FeeVault.sol";
// import { BaseFeeVault as BaseFeeVault_Final } from "@eth-optimism-bedrock/src/L2/BaseFeeVault.sol";

// /**
//  * @notice Upgrades the Fee Vaults through two implementation contracts:
//  *  1. The first sets the totalProcessed amount to some "correct" amount
//  *  2. The second sets the contract to the final intended implementation
//  */
// contract FixFeeVaultsL2 is NestedMultisigBuilder {
//     ProxyAdmin PROXY_ADMIN = PROXY_ADMIN(Predeploys.PROXY_ADMIN);

//     address constant internal SequencerFeeVault = Predeploys.SEQUENCER_FEE_WALLET;
//     address constant internal L1FeeVault = Predeploys.L1_FEE_VAULT;
//     address constant internal BaseFeeVault = Predeploys.BASE_FEE_VAULT;

//     address constant internal SequencerFeeVaultImpl_1; // TODO
//     address constant internal L1FeeVaultImpl_1; // TODO
//     address constant internal BaseFeeVaultImpl_1; // TODO

//     address constant internal SequencerFeeVaultImpl_Final; // TODO
//     address constant internal L1FeeVaultImpl_Final; // TODO
//     address constant internal BaseFeeVaultImpl_Final; // TODO

//     address constant internal L2_NESTED_SAFE = 0x4c7C99555e8afac3571c7456448021239F5b73bA;

//     uint256 constant internal SEQUENCER_VAULT_TARGET_TOTAL_PROCESSED; // TODO: calculate int or look up on Etherscan
//     uint256 constant internal L1_VAULT_TARGET_TOTAL_PROCESSED; // TODO: calculate int or look up on Etherscan
//     uint256 constant internal BASE_VAULT_TARGET_TOTAL_PROCESSED; // TODO: calculate int or look up on Etherscan

//     /**
//      * @notice Builds the following calls for each vault:
//      *   1. upgradeAndCall to intermediate implementation
//      *   2. upgrade to final implementation (w/ init as necessary)
//      */
//     function _buildCalls() internal override view returns (IMulticall3.Call3[] memory) {

//         IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](6);

//         bytes memory setTotalProcessedSequencer = abi.encodeCall(
//             FeeVault.setTotalProcessed, (SEQUENCER_VAULT_TARGET_TOTAL_PROCESSED)
//         );

//         bytes memory setTotalProcessedL1 = abi.encodeCall(
//             FeeVault.setTotalProcessed, (L1_VAULT_TARGET_TOTAL_PROCESSED)
//         );

//         bytes memory setTotalProcessedBase = abi.encodeCall(
//             FeeVault.setTotalProcessed, (BASE_VAULT_TARGET_TOTAL_PROCESSED)
//         );

//         ///
//         // SEQUENCER FEE VAULT CALLS
//         ///
//         calls[0] = IMulticall3.Call3({
//             target: PROXY_ADMIN,
//             allowFailure: false,
//             callData: abi.encodeCall(
//                 PROXY_ADMIN.upgradeAndCall,
//                 (
//                     SequencerFeeVault,
//                     SequencerFeeVaultImpl_1,
//                     setTotalProcessedSequencer
//                 )
//             )
//         });

//         calls[1] = IMulticall3.Call3({
//             target: PROXY_ADMIN,
//             allowFailure: false,
//             callData: abi.encodeCall(
//                 PROXY_ADMIN.upgrade,
//                 (
//                     SequencerFeeVault,
//                     SequencerFeeVaultImpl_Final
//                 )
//             )
//         });

//         ///
//         // L1 FEE VAULT CALLS
//         ///
//         calls[2] = IMulticall3.Call3({
//             target: PROXY_ADMIN,
//             allowFailure: false,
//             callData: abi.encodeCall(
//                 PROXY_ADMIN.upgradeAndCall,
//                 (
//                     L1FeeVault,
//                     L1FeeVaultImpl_1,
//                     setTotalProcessedL1
//                 )
//             )
//         });

//         calls[3] = IMulticall3.Call3({
//             target: PROXY_ADMIN,
//             allowFailure: false,
//             callData: abi.encodeCall(
//                 PROXY_ADMIN.upgrade,
//                 (
//                     L1FeeVault,
//                     L1FeeVaultImpl_Final
//                 )
//             )
//         });

//         ///
//         // BASE FEE VAULT CALLS
//         ///
//         calls[4] = IMulticall3.Call3({
//             target: PROXY_ADMIN,
//             allowFailure: false,
//             callData: abi.encodeCall(
//                 PROXY_ADMIN.upgradeAndCall,
//                 (
//                     BaseFeeVault,
//                     BaseFeeVaultImpl_1,
//                     setTotalProcessedBase
//                 )
//             )
//         });

//         calls[5] = IMulticall3.Call3({
//             target: PROXY_ADMIN,
//             allowFailure: false,
//             callData: abi.encodeCall(
//                 PROXY_ADMIN.upgrade,
//                 (
//                     BaseFeeVault,
//                     BaseFeeVaultImpl_Final
//                 )
//             )
//         });

//         return calls;
//     }

//     function _ownerSafe() internal override view returns (address) {
//         return L2_NESTED_SAFE;
//     }

//     /**
//      * @notice Checks for the following conditions:
//      *   1. The new implementation codehash matches the intended
//      *   2. The "totalProcessed" amount matches the target
//      */
//     function _postCheck() internal override view {
//          require(
//             proxyAdmin.getProxyImplementation(SequencerFeeVault).codehash == SequencerFeeVaultImpl_Final.codehash,
//             "FixFeeVaultsL2: SequencerFeeVault not upgraded"
//         );
//         require(
//             SequencerFeeVault(SequencerFeeVaultImpl_Final).totalProcessed() == SEQUENCER_VAULT_TARGET_TOTAL_PROCESSED
//         );


//         require(
//             proxyAdmin.getProxyImplementation(L1FeeVault).codehash == L1FeeVaultImpl_Final.codehash,
//             "FixFeeVaultsL2: L1FeeVault not upgraded"
//         );
//         require(
//             L1FeeVault(L1FeeVaultImpl_Final).totalProcessed() == L1_VAULT_TARGET_TOTAL_PROCESSED
//         );

//         require(
//             proxyAdmin.getProxyImplementation(BaseFeeVault).codehash == BaseFeeVaultImpl_Final.codehash,
//             "FixFeeVaultsL2: BaseFeeVault not upgraded"
//         );
//         require(
//             BaseFeeVault(BaseFeeVaultImpl_Final).totalProcessed() == BASE_VAULT_TARGET_TOTAL_PROCESSED
//         );
//     }
// }
