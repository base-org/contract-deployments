// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@base-contracts/script/universal/MultisigBuilder.sol";
import "@eth-optimism-bedrock/contracts/L1/OptimismPortal.sol";

contract PausePortal is MultisigBuilder {
    // address constant internal OPTIMISM_PORTAL_PROXY = <TODO: insert OptimismPortalProxy address>; // mainnet value: 0x49048044D57e1C92A77f79988d21Fa8fAF74E97e
    // address constant internal GUARDIAN = <TODO: insert multisig which is Guardian address>; // mainnet value: 0x14536667Cd30e52C0b458BaACcB9faDA7046E056

    function _postCheck() internal override view {
        OptimismPortal optimismPortal = OptimismPortal(OPTIMISM_PORTAL_PROXY);
        require(optimismPortal.paused() == true, "PausePortal: Portal did not get paused");
    }

    function _buildCalls() internal override view returns (IMulticall3.Call3[] memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](1);

        calls[0] = IMulticall3.Call3({
            target: PROXY_CONTRACT,
            allowFailure: false,
            callData: abi.encodeCall(
                OptimismPortal.pause, ()
            )
        });

        return calls;
    }

    function _ownerSafe() internal override view returns (address) {
        return GUARDIAN;
    }
}
