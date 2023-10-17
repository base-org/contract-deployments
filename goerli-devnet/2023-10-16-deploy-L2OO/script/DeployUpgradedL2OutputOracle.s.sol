// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@eth-optimism-bedrock/contracts/L1/L2OutputOracle.sol";
import "forge-std/Script.sol";

contract DeployUpgradedL2OutputOracle is Script {
    uint256 newSubmissionInterval = vm.envUint("NEW_SUBMISSION_INTERVAL");
    address deployer = vm.envAddress("DEPLOYER");
    address l2OOProxy = vm.envAddress("L2_OUTPUT_ORACLE_PROXY");

    function run() public {
        console.log(newSubmissionInterval);
        console.log(l2OOProxy);
        L2OutputOracle existingL2OO = L2OutputOracle(l2OOProxy);
        uint256 oldSubmissionInterval = existingL2OO.SUBMISSION_INTERVAL();
        uint256 oldL2BlockTime = existingL2OO.L2_BLOCK_TIME();
        uint256 oldFinalizationPeriodSeconds = existingL2OO.FINALIZATION_PERIOD_SECONDS();
        uint256 startingBlockNumber = existingL2OO.startingBlockNumber();
        uint256 startingTimestamp = existingL2OO.startingTimestamp();
        address oldProposer = existingL2OO.PROPOSER();
        address oldChallenger = existingL2OO.CHALLENGER();

        console.log(oldSubmissionInterval);
        console.log(oldL2BlockTime);
        console.log(oldFinalizationPeriodSeconds);

        // Deploy L2OutputOracle new implementation wiht the new submission interval
        vm.broadcast(deployer);
        L2OutputOracle l2OutputOracleImpl = new L2OutputOracle({
            _submissionInterval: newSubmissionInterval,
            _l2BlockTime: oldL2BlockTime,
            _startingBlockNumber: startingBlockNumber,
            _startingTimestamp: startingTimestamp,
            _proposer: oldProposer,
            _challenger: oldChallenger,
            _finalizationPeriodSeconds: oldFinalizationPeriodSeconds            
        });

        require(l2OutputOracleImpl.L2_BLOCK_TIME() == oldL2BlockTime, "Deploy: l2OutputOracle l2BlockTime is incorrect");
        require(l2OutputOracleImpl.FINALIZATION_PERIOD_SECONDS() == oldFinalizationPeriodSeconds, "Deploy: l2OutputOracle finalizationPeriodSeconds is incorrect");

        console.logAddress(address(l2OutputOracleImpl));
    }
}
