// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@base-contracts/src/TestOwner.sol";
import "@base-contracts/script/universal/NestedMultisigBuilder.sol";

contract TestNestedSafeL2 is NestedMultisigBuilder {
    address constant internal TEST_CONTRACT = 0xbc3895EaE104fE86b60E4838013e2fd1373C1047;
    address constant internal L2_NESTED_SAFE = 0xf71a498086d00843d7754964B27dd7198a16Ee7F;

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