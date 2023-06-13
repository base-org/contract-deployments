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
        address optimismPortal = 0x61A7dc680a0f3F67aDc357453d3f51bDc70fAE1B;
        uint64 gasLimit = 1000000; // TODO: tune this

        // Call increment()
        calls[0] = IMulticall3.Call3({
            target: optimismPortal,
            allowFailure: false,
            callData: abi.encodeCall(
                OptimismPortal.depositTransaction,
                (to, uint256(0), gasLimit, false, data)
            )
        });

        return abi.encodeCall(IMulticall3.aggregate3, (calls));
    }
}
