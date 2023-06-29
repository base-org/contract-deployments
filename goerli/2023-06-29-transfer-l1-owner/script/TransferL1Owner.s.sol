// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {
    OwnableUpgradeable
} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@base-contracts/script/universal/MultisigBuilder.sol";

contract TransferL1Owner is MultisigBuilder {
    address constant internal PROXY_ADMIN_OWNER = 0xbc0Fc544736b7d610D9b05F31B182C8154BEf336;
    address constant internal OLD_OWNER = 0x4C35Ca57616E0d5fD808574772f632D8dA4eadCa;
    address constant internal NEW_OWNER = 0x444b8C3E4eA49cE15A93D96AfA83D421F6049524;

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