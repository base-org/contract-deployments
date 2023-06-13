// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import { console } from "forge-std/console.sol";
import { SafeBuilder } from "@eth-optimism-bedrock/scripts/universal/SafeBuilder.sol";
import { IMulticall3 } from "forge-std/interfaces/IMulticall3.sol";
import { SystemConfig } from "@eth-optimism-bedrock/contracts/L1/SystemConfig.sol";

/**
 * @title SetBatcherAddr
 * @notice Script for setting the system config batcher address from a gnosis safe.
 */
contract SetBatcherAddr is SafeBuilder {
    address constant internal NewBatcher = 0x73b4168Cc87F35Cc239200A20Eb841CdeD23493B;
    address constant internal SystemConfigAddr = 0xb15eea247eCE011C68a614e4a77AD648ff495bc1;

    /**
     * @notice Follow up assertions to ensure that the script ran to completion.
     */
    function _postCheck() internal override view {
        SystemConfig systemConfig = SystemConfig(SystemConfigAddr);
        bytes32 batcherHash = bytes32(abi.encode(NewBatcher));
        require(systemConfig.batcherHash() == batcherHash, "SetBatcherAddr: batcherHash not set correctly");
    }

    /**
     * @notice Builds the calldata that the multisig needs to make for the upgrade to happen.
     *         A total of 8 calls are made, 7 upgrade implementations and 1 sets the resource
     *         config to the default value in the SystemConfig contract.
     */
    function buildCalldata(address _proxyAdmin) internal override pure returns (bytes memory) {
        require(_proxyAdmin == SystemConfigAddr, "SetBatcherAddr: unexpected proxyAdmin address value");

        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](1);

        bytes32 batcherHash = bytes32(abi.encode(NewBatcher));

        calls[0] = IMulticall3.Call3({
            target: SystemConfigAddr,
            allowFailure: false,
            callData: abi.encodeCall(
                SystemConfig.setBatcherHash,
                (batcherHash)
            )
        });

        return abi.encodeCall(IMulticall3.aggregate3, (calls));
    }
}
