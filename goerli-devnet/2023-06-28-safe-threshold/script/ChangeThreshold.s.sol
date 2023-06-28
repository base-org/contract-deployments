// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {
    OwnableUpgradeable
} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@base-contracts/script/universal/MultisigBuilder.sol";
import { IGnosisSafe, Enum } from "@eth-optimism-bedrock/scripts/interfaces/IGnosisSafe.sol";


contract ChangeThreshold is MultisigBuilder {
    address constant internal SAFE = 0x185D1422dccCf117D547fF2F278be88FDA59b240;

    function _postCheck() internal override view {
        // perform post execution checks
        IGnosisSafe safe = IGnosisSafe(payable(SAFE));
        require(safe.getThreshold() == 1, "Threshold should now be 1");
    }

    function _buildCalls() internal override view returns (IMulticall3.Call3[] memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](1);

        calls[0] = IMulticall3.Call3({
            target: SAFE,
            allowFailure: false,
            callData: abi.encodeCall(
                IGnosisSafe.changeThreshold, (1)
            )
        });

        return calls;
    }

    function _ownerSafe() internal override view returns (address) {
        return SAFE;
    }
}