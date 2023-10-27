// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@base-contracts/script/universal/MultisigBuilder.sol";
import { IGnosisSafe } from "@eth-optimism-bedrock/scripts/interfaces/IGnosisSafe.sol";

contract UpdateOwners is MultisigBuilder {
    address constant internal SAFE = 0x7768171512911988ACfCE3Fd295A4Cf8AA8E8dBA; 
    address constant internal NEW_OWNER_1 = 0x6E3af66aB774B54ca07f86d191BeF37ad4510Bdf;
    address constant internal NEW_OWNER_2 = 0x0Cd11fed1bA494866D5880D38e80d6bC9d330004;
    address constant internal NEW_OWNER_3 = 0x33c26Ec7FC538B6939776c6b1F1C6033B28Df3b1;
    address constant internal NEW_OWNER_4 = 0xe2Ef00887731F5dC55D66C5Acca3b9b365854D4D;
    address constant internal NEW_OWNER_5 = 0x4e52A3438f219b29327807D8D7962454b6799136;
    address constant internal NEW_OWNER_6 = 0x7a601cd27f4B46798e25331b7cf3EDaCB551aFcd;

    function _postCheck() internal override view {
        IGnosisSafe safe = IGnosisSafe(SAFE);
        require(safe.getOwners().length == 12, "GnosisSafe owners did not get updated");
        require(safe.getThreshold() == 2, "GnosisSafe threshold is incorrect");
    }

    function _buildCalls() internal override view returns (IMulticall3.Call3[] memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](6);
    
        calls[0] = IMulticall3.Call3({
            target: SAFE,
            allowFailure: false,
            callData: abi.encodeCall(
                IGnosisSafe.addOwnerWithThreshold,
                (NEW_OWNER_1, 1)
            )
        });

        calls[1] = IMulticall3.Call3({
            target: SAFE,
            allowFailure: false,
            callData: abi.encodeCall(
                IGnosisSafe.addOwnerWithThreshold,
                (NEW_OWNER_2, 1)
            )
        });

        calls[2] = IMulticall3.Call3({
            target: SAFE,
            allowFailure: false,
            callData: abi.encodeCall(
                IGnosisSafe.addOwnerWithThreshold,
                (NEW_OWNER_3, 1)
            )
        });

        calls[3] = IMulticall3.Call3({
            target: SAFE,
            allowFailure: false,
            callData: abi.encodeCall(
                IGnosisSafe.addOwnerWithThreshold,
                (NEW_OWNER_4, 1)
            )
        });

        calls[4] = IMulticall3.Call3({
            target: SAFE,
            allowFailure: false,
            callData: abi.encodeCall(
                IGnosisSafe.addOwnerWithThreshold,
                (NEW_OWNER_5, 1)
            )
        });

        calls[5] = IMulticall3.Call3({
            target: SAFE,
            allowFailure: false,
            callData: abi.encodeCall(
                IGnosisSafe.addOwnerWithThreshold,
                (NEW_OWNER_6, 2)
            )
        });

        return calls;
    }

    function _ownerSafe() internal override view returns (address) {
        return SAFE;
    }
}