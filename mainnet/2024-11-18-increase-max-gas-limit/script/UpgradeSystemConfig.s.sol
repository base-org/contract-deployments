// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {Vm} from "forge-std/Vm.sol";
import {IMulticall3} from "forge-std/interfaces/IMulticall3.sol";

import {SystemConfig} from "@eth-optimism-bedrock/src/L1/SystemConfig.sol";
import {MultisigBuilder, Simulation} from "@base-contracts/script/universal/MultisigBuilder.sol";

interface IProxyAdmin {
    function implementation() external view returns (address);
    function upgradeTo(address _implementation) external;
}

contract UpgradeSystemConfig is MultisigBuilder {
    address internal SYSTEM_CONFIG_OWNER = vm.envAddress("SYSTEM_CONFIG_OWNER");
    address internal SYSTEM_CONFIG_ADDRESS = vm.envAddress("SYSTEM_CONFIG_ADDRESS");
    address internal NEW_IMPLEMENTATION = vm.envAddress("NEW_IMPLEMENTATION");

    function _postCheck(Vm.AccountAccess[] memory, Simulation.Payload memory) internal view override {
        require(IProxyAdmin(SYSTEM_CONFIG_ADDRESS).implementation() == NEW_IMPLEMENTATION);
    }

    function _buildCalls() internal view override returns (IMulticall3.Call3[] memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](3);

        // FIXME: Doe snot work as the SystemConfig is gated by `proxyCallIfNotAdmin`.
        calls[0] = IMulticall3.Call3({
            target: SYSTEM_CONFIG_ADDRESS,
            allowFailure: false,
            callData: abi.encodeCall(IProxyAdmin.upgradeTo, (NEW_IMPLEMENTATION))
        });

        return calls;
    }

    function _ownerSafe() internal view override returns (address) {
        return SYSTEM_CONFIG_OWNER;
    }
}
