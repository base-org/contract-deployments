// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@eth-optimism-bedrock/contracts/L1/L2OutputOracle.sol";
import "@base-contracts/src/Challenger1of2.sol";
import "@base-contracts/script/universal/MultisigBuilder.sol";

contract DeleteL2Outputs is MultisigBuilder {
    // address constant internal L2_OUTPUT_ORACLE_PROXY = <TODO: insert L2OutputOracleProxy address>;
    //      mainnet value: 0x56315b90c40730925ec5485cf004d835058518A0
    //      goerli value: 0x2A35891ff30313CcFa6CE88dcf3858bb075A2298
    // address constant internal CHALLENGER = <TODO: insert challenger contract address>;
    //      mainnet value: TBD
    //      goerli value: 0xf30b40411c4d76228092E7eCdc1593c996b13D22
    // address constant internal SAFE = <TODO: insert multisig which is signer on challenger>;
    //      mainnet value: 0x14536667Cd30e52C0b458BaACcB9faDA7046E056
    //      goerli value: 0x4C35Ca57616E0d5fD808574772f632D8dA4eadCa
    // uint256 constant internal L2_OUTPUT_INDEX = <TODO: insert l2OuputIndex to start deleting from - everything after will be deleted>;

    function _postCheck() internal override view {
        L2OutputOracle l2OutputOracle = L2OutputOracle(L2_OUTPUT_ORACLE_PROXY);
        require(l2OutputOracle.latestOutputIndex() < L2_OUTPUT_INDEX, "DeleteL2Outputs: L2OutputOracle did not get deleted");
    }

    function _buildCalls() internal override view returns (IMulticall3.Call3[] memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](1);

        L2OutputOracle l2OutputOracle = L2OutputOracle(L2_OUTPUT_ORACLE_PROXY);
        bytes memory deleteL2OutputData = abi.encodeCall(
            L2OutputOracle.deleteL2Outputs, (L2_OUTPUT_INDEX)
        );

        calls[0] = IMulticall3.Call3({
            target: CHALLENGER,
            allowFailure: false,
            callData: abi.encodeCall(
                Challenger1of2.execute, (deleteL2OutputData)
            )
        });

        return calls;
    }

    function _ownerSafe() internal override view returns (address) {
        return SAFE;
    }
}
