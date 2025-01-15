// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {
    OwnableUpgradeable
} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@base-contracts/script/universal/MultisigBuilder.sol";

// TODO: alternatively, can use NestedMultisigBuilder if existing owner is nested safe
contract TransferOwner is MultisigBuilder {
    address constant internal PROXY_CONTRACT = vm.envAddress("PROXY_CONTRACT"); // TODO: define PROXY_CONTRACT=xxx in the .env file which is the Proxy contract changing ownership
    address constant internal OLD_OWNER = vm.envAddress("OLD_OWNER"); // TODO: define existing owner as OLD_OWNER=xxx in the .env file
    address constant internal NEW_OWNER = vm.envAddress("NEW_OWNER"); // TODO: define new owner as NEW_OWNER=xxx in the .env file

    function _postCheck() internal override view {
        ProxyAdmin proxyAdmin = ProxyAdmin(PROXY_CONTRACT);
        require(proxyAdmin.owner() == NEW_OWNER, "ProxyAdmin owner did not get updated");
    }

    function _buildCalls() internal override view returns (IMulticall3.Call3[] memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](1);

        calls[0] = IMulticall3.Call3({
            target: PROXY_CONTRACT,
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