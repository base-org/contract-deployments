// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {
    OwnableUpgradeable
} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@base-contracts/script/universal/MultisigBuilder.sol";

contract TransferL2Owner is MultisigBuilder {
    address constant internal PROXY_ADMIN = 0x4200000000000000000000000000000000000018;
    address constant internal OLD_OWNER = 0x2eD486761dcF287E7b79E526B0d3fC2349834a66;
    address constant internal NEW_OWNER = 0x4c7C99555e8afac3571c7456448021239F5b73bA;

    function _postCheck() internal override view {
        // perform post execution checks
        ProxyAdmin proxyAdmin = new ProxyAdmin(PROXY_ADMIN);
        require(proxyAdmin.owner() == NEW_OWNER, "Deploy: proxyAdmin owner is incorrect");
    }

    function _buildCalls() internal override view returns (IMulticall3.Call3[] memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](1);

        calls[0] = IMulticall3.Call3({
            target: PROXY_ADMIN,
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