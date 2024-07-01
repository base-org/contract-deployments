// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@base-contracts/script/universal/MultisigBuilder.sol";
import "@eth-optimism-bedrock/src/L1/OptimismPortal.sol";

contract UnpausePortal is MultisigBuilder {
    address constant internal OPTIMISM_PORTAL_PROXY = vm.envAddress("OPTIMISM_PORTAL_PROXY"); // TODO: define OPTIMISM_PORTAL_PROXY=xxx in the .env file
    address constant internal GUARDIAN = vm.envAddress("GUARDIAN"); // TODO: define GUARDIAN=xxx in the .env file

    function _postCheck() internal override view {
        OptimismPortal optimismPortal = OptimismPortal(payable(OPTIMISM_PORTAL_PROXY));
        require(optimismPortal.paused() == false, "UnpausePortal: Portal did not get unpaused");
    }

    function _buildCalls() internal override view returns (IMulticall3.Call3[] memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](1);

        calls[0] = IMulticall3.Call3({
            target: OPTIMISM_PORTAL_PROXY,
            allowFailure: false,
            callData: abi.encodeCall(
                OptimismPortal.unpause, ()
            )
        });

        return calls;
    }

    function _ownerSafe() internal override view returns (address) {
        return GUARDIAN;
    }
}
