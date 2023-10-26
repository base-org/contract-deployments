// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@eth-optimism-bedrock/contracts/L1/L2OutputOracle.sol";
import "@base-contracts/src/Challenger1of2.sol";
import "@base-contracts/script/universal/MultisigBuilder.sol";

contract DeleteL2Outputs is MultisigBuilder {
    address constant internal L2_OUTPUT_ORACLE_PROXY = 0x805fbEDB43E814b2216ce6926A0A19bdeDb0C8Cd;
    address constant internal CHALLENGER = 0x6c4219fC0DA6813FbB3301F103813fe230FA6653;
    address constant internal SAFE = 0xA221e753e82626F96b83b3665F4fA92114a2a6f3;
    uint256 constant internal L2_OUTPUT_INDEX = 20235;

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
