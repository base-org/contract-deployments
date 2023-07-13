// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@eth-optimism-bedrock/contracts/l1/L2OutputOracle.sol";
import "@eth-optimism-bedrock/contracts/universal/ProxyAdmin.sol";
import "@base-contracts/script/universal/NestedMultisigBuilder.sol";

contract UpgradeL2OutputOracle is NestedMultisigBuilder {
    address constant internal PROXY_ADMIN_CONTRACT = 0xbc0Fc544736b7d610D9b05F31B182C8154BEf336;
    address constant internal PROXY_ADMIN_OWNER = 0x444b8C3E4eA49cE15A93D96AfA83D421F6049524; // Nested Safe addr
    address constant internal L2_OUTPUT_ORACLE_PROXY = 0x2A35891ff30313CcFa6CE88dcf3858bb075A2298;
    address constant internal NEW_IMPLEMENTATION = 0x551E1aa0e21b1c7dD408dBFb31f1368A987df622;
    address constant internal CHALLENGER = 0xf30b40411c4d76228092E7eCdc1593c996b13D22;

    function _postCheck() internal override view {
        ProxyAdmin proxyAdmin = ProxyAdmin(PROXY_ADMIN_CONTRACT);
        require(proxyAdmin.getProxyImplementation(L2_OUTPUT_ORACLE_PROXY).codehash == NEW_IMPLEMENTATION.codehash);
    }

    function _buildCalls() internal override view returns (IMulticall3.Call3[] memory) {
        L2OutputOracle oldContract = L2OutputOracle(L2_OUTPUT_ORACLE_PROXY);
        L2OutputOracle newContract = L2OutputOracle(NEW_IMPLEMENTATION);

        require(oldContract.SUBMISSION_INTERVAL() == newContract.SUBMISSION_INTERVAL(), "Upgrade: l2OutputOracle submissionInterval is incorrect");
        require(oldContract.L2_BLOCK_TIME() == newContract.L2_BLOCK_TIME(), "Upgrade: l2OutputOracle l2BlockTime is incorrect");
        require(oldContract.PROPOSER() == newContract.PROPOSER(), "Upgrade: l2OutputOracle proposer is incorrect");
        require(oldContract.FINALIZATION_PERIOD_SECONDS() == newContract.FINALIZATION_PERIOD_SECONDS(), "Upgrade: l2OutputOracle finalizationPeriodSeconds is incorrect");

        require(newContract.CHALLENGER() == CHALLENGER, "Upgrade: l2OutputOracle challenger is incorrect");

        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](1);

        calls[0] = IMulticall3.Call3({
            target: PROXY_ADMIN_CONTRACT,
            allowFailure: false,
            callData: abi.encodeCall(
                ProxyAdmin.upgrade,
                (payable(L2_OUTPUT_ORACLE_PROXY), NEW_IMPLEMENTATION)
            )
        });

        return calls;
    }

    function _ownerSafe() internal override view returns (address) {
        return PROXY_ADMIN_OWNER;
    }
}