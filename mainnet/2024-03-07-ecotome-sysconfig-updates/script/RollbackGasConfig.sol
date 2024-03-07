// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {SystemConfig} from "@eth-optimism-bedrock/src/L1/SystemConfig.sol";
import {MultisigBuilder, IMulticall3} from "@base-contracts/script/universal/MultisigBuilder.sol";

contract RollbackGasConfig is MultisigBuilder {

    address internal SYSTEM_CONFIG_OWNER = vm.envAddress("SYSTEM_CONFIG_OWNER");
    address internal L1_SYSTEM_CONFIG = vm.envAddress("L1_SYSTEM_CONFIG_ADDRESS");
    uint256 internal FALLBACK_SCALAR = vm.envUint("FALLBACK_SCALAR");

    function _postCheck() internal override view {
        require(SystemConfig(L1_SYSTEM_CONFIG).scalar() == FALLBACK_SCALAR);
        require(SystemConfig(L1_SYSTEM_CONFIG).overhead() == 0);
    }

    function _buildCalls() internal override view returns (IMulticall3.Call3[] memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](1);

        calls[0] = IMulticall3.Call3({
            target: L1_SYSTEM_CONFIG,
            allowFailure: false,
            callData: abi.encodeCall(
                SystemConfig.setGasConfig,
                (
                0, // overhead is not used post Ecotome
                FALLBACK_SCALAR
                )
            )
        });

        return calls;
    }

    function _ownerSafe() internal override view returns (address) {
        return SYSTEM_CONFIG_OWNER;
    }
}