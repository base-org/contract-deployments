// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@eth-optimism-bedrock/src/L1/SystemConfig.sol";
import "@base-contracts/script/universal/MultisigBuilder.sol";

contract SetBatcherAddr is MultisigBuilder {
    address constant internal NEW_BATCHER = vm.envAddress("NEW_BATCHER_ADDR"); // TODO: define NEW_BATCHER_ADDR=xxx in the .env file
    address constant internal SYSTEM_CONFIG = vm.envAddress("SYSTEM_CONFIG_ADDR"); // TODO: define SYSTEM_CONFIG_ADDR=xxx in the .env file
    address internal SYSTEM_CONFIG_OWNER = vm.envAddress("SYSTEM_CONFIG_OWNER"); // TODO: define SYSTEM_CONFIG_OWNER=xxx in the .env file


    function _postCheck() internal override view {
        SystemConfig systemConfig = SystemConfig(SYSTEM_CONFIG);
        bytes32 batcherHash = bytes32(abi.encode(NEW_BATCHER));
        require(systemConfig.batcherHash() == batcherHash, "SetBatcherAddr: batcherHash not set correctly");
    }

    function _buildCalls() internal override view returns (IMulticall3.Call3[] memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](1);

        bytes32 batcherHash = bytes32(abi.encode(NEW_BATCHER));

        calls[0] = IMulticall3.Call3({
            target: SYSTEM_CONFIG,
            allowFailure: false,
            callData: abi.encodeCall(
                SystemConfig.setBatcherHash,
                (batcherHash)
            )
        });

        return calls;
    }

    function _ownerSafe() internal override view returns (address) {
        return SYSTEM_CONFIG_OWNER;
    }
}