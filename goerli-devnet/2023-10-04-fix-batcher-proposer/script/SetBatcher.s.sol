// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@eth-optimism-bedrock/src/L1/SystemConfig.sol";
import "@base-contracts/script/universal/MultisigBuilder.sol";

contract SetBatcherAddr is MultisigBuilder {
    address constant internal NewBatcher = 0xf298c4836d17994556d941B51F0800AA034E7F11;
    address constant internal SystemConfigAddr = 0x4f775d578e3Ab8ce81f5Ec065050938DbD5Fb8c2;
    address internal PROXY_ADMIN_OWNER = 0xA221e753e82626F96b83b3665F4fA92114a2a6f3;


    function _postCheck() internal override view {
        SystemConfig systemConfig = SystemConfig(SystemConfigAddr);
        bytes32 batcherHash = bytes32(abi.encode(NewBatcher));
        require(systemConfig.batcherHash() == batcherHash, "SetBatcherAddr: batcherHash not set correctly");
    }

    function _buildCalls() internal override view returns (IMulticall3.Call3[] memory) {
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

        return calls;
    }

    function _ownerSafe() internal override view returns (address) {
        return PROXY_ADMIN_OWNER;
    }
}