// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "src/TestIncrement.sol";
import "@base-contracts/script/upgrade/SafeBuilder.sol";

import { OptimismPortal } from "@eth-optimism-bedrock/contracts/L1/OptimismPortal.sol";

contract SafeForcedInclusion is SafeBuilder {
    function _postCheck() internal override view {
    }

    function buildCalldata() internal override view returns (bytes memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](1);

        bytes memory data = abi.encodeCall(TestIncrement.increment, ());
        address to = 0xc1e40f9FD2bc36150e2711e92138381982988791; // TestIncrement contract on L2
        address multicallAddress = 0xcA11bde05977b3631167028862bE2a173976CA11;

        // Call increment()
        calls[0] = IMulticall3.Call3({
            target: to,
            allowFailure: false,
            callData: data
        });

        return abi.encodeCall(
            OptimismPortal.depositTransaction,
            (
                multicallAddress,
                uint256(0),
                uint64(1000000),
                false,
                abi.encodeCall(IMulticall3.aggregate3, (calls))
            )
        );
    }
}