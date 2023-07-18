// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {
    OwnableUpgradeable
} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@base-contracts/script/universal/NestedMultisigBuilder.sol";
import "@eth-optimism-bedrock/contracts/universal/ProxyAdmin.sol";


contract TestL1NestedSafe is NestedMultisigBuilder {
    address constant internal PROXY_ADMIN_CONTRACT = 0x004BC95c786dc50b42cC573458cC39ba82d98C09;
    address constant internal PROXY_CONTRACT = 0x9fc9A8f624DfAc7AFF00676AEB96c6Ab7d5c0CeC;
    address constant internal OLD_IMPLEMENTATION = 0x78F29A0a59818C17D9842bD1eeB11E0704709946;
    address constant internal NEW_IMPLEMENTATION = 0x4a7E687066bb29C18DA16b152D234C652D774fED;
    address constant internal NESTED_L1_SAFE = 0x9B3245a57C339FC711921894c012A4FA53F5F343;
    address constant internal NEW_OWNER = address(1);

    function _postCheck() internal override view {
        ProxyAdmin proxyAdmin = ProxyAdmin(PROXY_ADMIN_CONTRACT);

        // Check contract was upgraded
        require(
            proxyAdmin.getProxyImplementation(PROXY_CONTRACT) == NEW_IMPLEMENTATION,
            "TestL1NestedSafe: implementation did not get set"
        );

        // Check proxy admin owner was upgraded
        require(proxyAdmin.owner() == NEW_OWNER, "TestL1NestedSafe: proxyAdmin owner is incorrect");
    }

    function _buildCalls() internal override view returns (IMulticall3.Call3[] memory) {
        ProxyAdmin proxyAdmin = ProxyAdmin(PROXY_ADMIN_CONTRACT);
        require(
            proxyAdmin.getProxyImplementation(PROXY_CONTRACT) == OLD_IMPLEMENTATION,
            "TestL1NestedSafe: implementation did not get set"
        );

        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](2);

        // Test 1: Upgrade a contract implementation
        calls[0] = IMulticall3.Call3({
            target: PROXY_ADMIN_CONTRACT,
            allowFailure: false,
            callData: abi.encodeCall(
                ProxyAdmin.upgrade,
                (payable(PROXY_CONTRACT), NEW_IMPLEMENTATION)
            )
        });

        // Test 2: Transfer ownership of proxy admin
        calls[1] = IMulticall3.Call3({
            target: PROXY_ADMIN_CONTRACT,
            allowFailure: false,
            callData: abi.encodeCall(
                OwnableUpgradeable.transferOwnership,
                (NEW_OWNER)
            )
        });

        return calls;
    }

    function _ownerSafe() internal override view returns (address) {
        return NESTED_L1_SAFE;
    }
}