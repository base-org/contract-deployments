// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@base-contracts/src/TestOwner.sol";
import "@base-contracts/script/universal/NestedMultisigBuilder.sol";

contract TestNestedSafeL2 is NestedMultisigBuilder {
    address constant internal TEST_CONTRACT = 0x7915f3785D9C12121262418F2331db2205124BC2;
    address constant internal L2_NESTED_SAFE = 0x4c7C99555e8afac3571c7456448021239F5b73bA;

    function _postCheck() internal override view {
        // perform post execution checks
    }

    function _buildCalls() internal override view returns (IMulticall3.Call3[] memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](1);

        calls[0] = IMulticall3.Call3({
            target: TEST_CONTRACT,
            allowFailure: false,
            callData: abi.encodeCall(
                TestOwner.increment,
                ()
            )
        });

        return calls;
    }

    function _ownerSafe() internal override view returns (address) {
        return L2_NESTED_SAFE;
    }
}