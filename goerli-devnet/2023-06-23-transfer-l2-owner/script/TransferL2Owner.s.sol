// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {
    OwnableUpgradeable
} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@base-contracts/script/universal/MultisigBuilder.sol";

contract TransferL2Owner is MultisigBuilder {
    address constant internal PROXY_ADMIN_OWNER = 0x4200000000000000000000000000000000000018;
    address constant internal OLD_OWNER = 0x7768171512911988ACfCE3Fd295A4Cf8AA8E8dBA;
    address constant internal NEW_OWNER = 0xf71a498086d00843d7754964B27dd7198a16Ee7F;

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