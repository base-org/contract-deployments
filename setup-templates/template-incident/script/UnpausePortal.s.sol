// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@base-contracts/script/universal/MultisigBuilder.sol";
import "@eth-optimism-bedrock/contracts/L1/OptimismPortal.sol";

contract UnpausePortal is MultisigBuilder {
    // address constant internal OPTIMISM_PORTAL_PROXY = <TODO: insert OptimismPortalProxy address>;
    //      mainnet value: 0x49048044D57e1C92A77f79988d21Fa8fAF74E97e
    //      goerli value: 0xe93c8cD0D409341205A592f8c4Ac1A5fe5585cfA
    // address constant internal GUARDIAN = <TODO: insert multisig which is Guardian address>;
    //      mainnet value: 0x14536667Cd30e52C0b458BaACcB9faDA7046E056
    //      goerli value: 0x4C35Ca57616E0d5fD808574772f632D8dA4eadCa

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
