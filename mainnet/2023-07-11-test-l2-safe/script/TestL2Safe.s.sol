// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {
    OwnableUpgradeable
} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@base-contracts/script/universal/MultisigBuilder.sol";
import "@eth-optimism-bedrock/contracts/universal/ProxyAdmin.sol";

contract TestL2Safe is MultisigBuilder {
    address constant internal PROXY_ADMIN_CONTRACT = 0x5170619f82f277c2B6BD3A9173CCb74D10B4B7d1;
    address constant internal PROXY_CONTRACT = 0x96ffD33D44792B73C573B9D773A2Af4623924aEE;
    address constant internal OLD_IMPLEMENTATION = 0xa56bCd3A713e2857b453ED38aD3052Bb7953e798;
    address constant internal NEW_IMPLEMENTATION = 0x004BC95c786dc50b42cC573458cC39ba82d98C09;
    address constant internal L2_SAFE = 0xd94E416cf2c7167608B2515B7e4102B41efff94f;
    address constant internal NEW_OWNER = address(1);

    function _postCheck() internal override view {
        ProxyAdmin proxyAdmin = ProxyAdmin(PROXY_ADMIN_CONTRACT);

        // Check contract was upgraded
        require(
            proxyAdmin.getProxyImplementation(PROXY_CONTRACT) == NEW_IMPLEMENTATION,
            "TestL2Safe: implementation did not get set"
        );

        // Check proxy admin owner was upgraded
        require(proxyAdmin.owner() == NEW_OWNER, "TestL2Safe: proxyAdmin owner is incorrect");
    }

    function _buildCalls() internal override view returns (IMulticall3.Call3[] memory) {
        ProxyAdmin proxyAdmin = ProxyAdmin(PROXY_ADMIN_CONTRACT);
        require(
            proxyAdmin.getProxyImplementation(PROXY_CONTRACT) == OLD_IMPLEMENTATION,
            "TestL2Safe: implementation did not get set"
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
        return L2_SAFE;
    }
}