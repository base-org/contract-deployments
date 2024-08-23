// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {ProxyAdmin} from "@eth-optimism-bedrock/src/universal/ProxyAdmin.sol";
import {L2OutputOracle} from "@eth-optimism-bedrock/src/L1/L2OutputOracle.sol";
import "forge-std/Script.sol";

contract UpdateProposer is Script {
    address internal NEW_PROPOSER = vm.envAddress("NEW_PROPOSER");
    address internal L2_OUTPUT_ORACLE_PROXY = vm.envAddress("L2_OUTPUT_ORACLE_PROXY");
    address internal PROXY_ADMIN = vm.envAddress("L1_PROXY_ADMIN");
    address internal PROXY_ADMIN_OWNER = vm.envAddress("PROXY_ADMIN_OWNER");

    function run() public {
        L2OutputOracle l2OOProxy = L2OutputOracle(L2_OUTPUT_ORACLE_PROXY);
        uint256 oldSubmissionInterval = l2OOProxy.SUBMISSION_INTERVAL();
        uint256 oldL2BlockTime = l2OOProxy.L2_BLOCK_TIME();
        uint256 oldFinalizationPeriodSeconds = l2OOProxy.FINALIZATION_PERIOD_SECONDS();
        uint256 startingBlockNumber = l2OOProxy.startingBlockNumber();
        uint256 startingTimestamp = l2OOProxy.startingTimestamp();
        address oldProposer = l2OOProxy.PROPOSER();
        address oldChallenger = l2OOProxy.CHALLENGER();
        console.log("Current proposer: ");
        console.log(oldProposer);
        console.log("New proposer to update: ");
        console.log(NEW_PROPOSER);

        L2OutputOracle l2OutputOracleImpl = new L2OutputOracle({
            _submissionInterval: oldSubmissionInterval,
            _l2BlockTime: oldL2BlockTime,
            _finalizationPeriodSeconds: oldFinalizationPeriodSeconds            
        });
        ProxyAdmin proxyAdmin = ProxyAdmin(PROXY_ADMIN);
        // vm.prank(PROXY_ADMIN_OWNER);
        proxyAdmin.upgradeAndCall(
            payable(L2_OUTPUT_ORACLE_PROXY),
            address(l2OutputOracleImpl),
            abi.encodeCall(
                L2OutputOracle.initialize,
                (
                    startingBlockNumber, startingTimestamp, NEW_PROPOSER, oldChallenger
                )
            )
        );

        require(l2OOProxy.L2_BLOCK_TIME() == oldL2BlockTime, "Deploy: l2OutputOracle l2BlockTime is incorrect");
        require(l2OOProxy.PROPOSER() == NEW_PROPOSER, "Deploy: l2OutputOracle proposer is incorrect");
        require(proxyAdmin.getProxyImplementation(L2_OUTPUT_ORACLE_PROXY).codehash == address(l2OutputOracleImpl).codehash, "Deploy: l2OutputOracle codehash is incorrect");
    }
}