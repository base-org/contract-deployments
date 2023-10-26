// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {
    OwnableUpgradeable
} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@base-contracts/script/universal/MultisigBuilder.sol";

contract TransferL1Owner is MultisigBuilder {
    address constant internal PROXY_ADMIN_OWNER = 0x4d56E97228bBF10DcB2ED7E8F455c57AbE247404;
    address constant internal OLD_OWNER = 0xA221e753e82626F96b83b3665F4fA92114a2a6f3;
    address constant internal NEW_OWNER = 0xCDdEb1F77Cbc9BD2Bd07aD5808CE6108EB07DF89;

    function _postCheck() internal override view {
        // perform post execution checks
    }

    function _buildCalls() internal override view returns (IMulticall3.Call3[] memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](1);

        calls[0] = IMulticall3.Call3({
            target: PROXY_ADMIN_OWNER,
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