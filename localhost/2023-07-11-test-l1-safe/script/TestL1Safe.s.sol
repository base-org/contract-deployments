// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {
    OwnableUpgradeable
} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@base-contracts/script/universal/MultisigBuilder.sol";
import "@eth-optimism-bedrock/contracts/universal/ProxyAdmin.sol";

contract TestL1Safe is MultisigBuilder {
    address constant internal PROXY_ADMIN_CONTRACT = 0x1613beB3B2C4f22Ee086B2b38C1476A3cE7f78E8;
    address constant internal PROXY_CONTRACT = 0x851356ae760d987E095750cCeb3bC6014560891C;
    address constant internal OLD_IMPLEMENTATION = 0xf5059a5D33d5853360D16C683c16e67980206f36;
    address constant internal NEW_IMPLEMENTATION = 0x95401dc811bb5740090279Ba06cfA8fcF6113778;
    address constant internal OLD_OWNER = 0x41715Dd88D95c3c80248f19DAcE21015346069b8;
    address constant internal NEW_OWNER = address(1);

    function _postCheck() internal override view {
        ProxyAdmin proxyAdmin = ProxyAdmin(PROXY_ADMIN_CONTRACT);

        // Check contract was upgraded
        require(
            proxyAdmin.getProxyImplementation(PROXY_CONTRACT) == NEW_IMPLEMENTATION,
            "TestL1Safe: implementation did not get set"
        );

        // Check proxy admin owner was upgraded
        require(proxyAdmin.owner() == NEW_OWNER, "TestL1Safe: proxyAdmin owner is incorrect");
    }

    function _buildCalls() internal override view returns (IMulticall3.Call3[] memory) {
        ProxyAdmin proxyAdmin = ProxyAdmin(PROXY_ADMIN_CONTRACT);
        require(
            proxyAdmin.getProxyImplementation(PROXY_CONTRACT) == OLD_IMPLEMENTATION,
            "TestL1Safe: implementation did not get set"
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
        return OLD_OWNER;
    }
}