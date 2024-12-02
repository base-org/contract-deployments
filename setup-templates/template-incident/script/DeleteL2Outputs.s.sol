// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@eth-optimism-bedrock/src/L1/L2OutputOracle.sol";
import "@base-contracts/src/Challenger1of2.sol";
import "@base-contracts/script/universal/MultisigBuilder.sol";

contract DeleteL2Outputs is MultisigBuilder {
    address constant internal L2_OUTPUT_ORACLE_PROXY = vm.envAddress("L2_OUTPUT_ORACLE_PROXY"); // TODO: define L2_OUTPUT_ORACLE_PROXY=xxx in the .env file
    address constant internal CHALLENGER = vm.envAddress("CHALLENGER"); // TODO: define CHALLENGER=xxx in the .env file
    address constant internal SAFE = vm.envAddress("SAFE"); // TODO: define SAFE=xxx in the .env file - ie the multisig which is signer on challenger>
    uint256 constant internal L2_OUTPUT_INDEX = vm.envAddress("L2_OUTPUT_INDEX"); // TODO: define L2_OUTPUT_INDEX=xxx in the .env file - this is the index start deleting from (everything after will be deleted)

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
