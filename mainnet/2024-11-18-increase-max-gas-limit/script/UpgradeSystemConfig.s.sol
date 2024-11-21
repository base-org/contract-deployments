// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import { IMulticall3 } from "forge-std/interfaces/IMulticall3.sol";
import { SystemConfig } from "@eth-optimism-bedrock/contracts/L1/SystemConfig.sol";
import { MultisigBuilder } from "@base-contracts/script/universal/MultisigBuilder.sol";

contract TransferSystemConfigOwner is MultisigBuilder {
    address internal SYSTEM_CONFIG_OWNER = vm.envAddress("SYSTEM_CONFIG_OWNER")
    address internal SYSTEM_CONFIG_ADDRESS = vm.envAddress("SYSTEM_CONFIG_ADDRESS");
    address constant internal NEW_IMPLEMENTATION = vm.envAddress("NEW_IMPLEMENTATION");

    function _postCheck() internal override view {
        require(SystemConfig(SYSTEM_CONFIG_ADDR).implementation() == NEW_IMPLEMENTATION);
    }

    function _buildCalls() internal override pure returns (IMulticall3.Call3[] memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](1);

        calls[0] = IMulticall3.Call3({
            target: SYTEM_CONFIG_ADDRESS,
            allowFailure: false,
            callData: abi.encodeCall(
                SystemConfig.upgradeTo,
                (NEW_IMPLEMENTATION)
            )
        });

        return calls;
    }

    function _ownerSafe() internal override view returns (address) {
        return SYSTEM_CONFIG_OWNER;
    }
}

