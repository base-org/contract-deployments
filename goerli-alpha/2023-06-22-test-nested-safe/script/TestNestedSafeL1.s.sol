// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@base-contracts/src/TestOwner.sol";
import "@base-contracts/script/universal/NestedMultisigBuilder.sol";

contract TestNestedSafeL1 is NestedMultisigBuilder {
    address constant internal TEST_CONTRACT = 0x5A95Ad66cb8b031bf5bA64669528E431c300723B;
    address constant internal L1_NESTED_SAFE = 0xCDdEb1F77Cbc9BD2Bd07aD5808CE6108EB07DF89;

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
        return L1_NESTED_SAFE;
    }
}