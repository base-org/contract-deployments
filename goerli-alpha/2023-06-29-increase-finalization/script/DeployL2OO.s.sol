// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@eth-optimism-bedrock/contracts/L1/L2OutputOracle.sol";
import "forge-std/Script.sol";

contract DeployL2OOImplementation is Script {
    function run(address deployer, uint256 finalizationPeriodSeconds, address l2OOProxy) public {
        require(deployer != address(0), "Deploy: deployer is zero address");
        require(finalizationPeriodSeconds > 0, "Deploy: finalizationPeriodSeconds is zero");
        require(l2OOProxy != address(0), "Deploy: l2OutputOracleProxy is zero address");

        L2OutputOracle existingL2OO = L2OutputOracle(l2OOProxy);
        uint256 oldSubmissionInterval = existingL2OO.SUBMISSION_INTERVAL();
        uint256 oldL2BlockTime = existingL2OO.L2_BLOCK_TIME();
        address oldProposer = existingL2OO.PROPOSER();
        address oldChallenger = existingL2OO.CHALLENGER();

        console.log(oldSubmissionInterval);
        console.log(oldL2BlockTime);
        console.log(oldProposer);
        console.log(oldChallenger);

        // Deploy L2OutputOracle new implementation with new challenger
        vm.broadcast(deployer);
        L2OutputOracle l2OutputOracleImpl = new L2OutputOracle({
            _submissionInterval: oldSubmissionInterval,
            _l2BlockTime: oldL2BlockTime,
            _startingBlockNumber: 0,
            _startingTimestamp: 0,
            _proposer: oldProposer,
            _challenger: oldChallenger,
            _finalizationPeriodSeconds: finalizationPeriodSeconds            
        });

        require(l2OutputOracleImpl.SUBMISSION_INTERVAL() == oldSubmissionInterval, "Deploy: l2OutputOracle submissionInterval is incorrect");
        require(l2OutputOracleImpl.L2_BLOCK_TIME() == oldL2BlockTime, "Deploy: l2OutputOracle l2BlockTime is incorrect");
        require(l2OutputOracleImpl.startingBlockNumber() == 0, "Deploy: l2OutputOracle startingBlockNumber is incorrect");
        require(l2OutputOracleImpl.startingTimestamp() == 0, "Deploy: l2OutputOracle startingTimestamp is incorrect");
        require(l2OutputOracleImpl.PROPOSER() == oldProposer, "Deploy: l2OutputOracle proposer is incorrect");
        require(l2OutputOracleImpl.CHALLENGER() == oldChallenger, "Deploy: l2OutputOracle challenger is incorrect");

        require(l2OutputOracleImpl.FINALIZATION_PERIOD_SECONDS() == finalizationPeriodSeconds, "Deploy: l2OutputOracle finalizationPeriodSeconds is incorrect");
    }
}
