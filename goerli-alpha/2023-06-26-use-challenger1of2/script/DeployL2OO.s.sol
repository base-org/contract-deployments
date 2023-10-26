// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@eth-optimism-bedrock/contracts/L1/L2OutputOracle.sol";
import "forge-std/Script.sol";

contract DeployL2OOImplementation is Script {
    function run(address deployer, address challenger, address l2OOProxy) public {
        require(deployer != address(0), "Deploy: deployer is zero address");
        require(challenger != address(0), "Deploy: challenger is zero address");
        require(l2OOProxy != address(0), "Deploy: l2OutputOracleProxy is zero address");

        L2OutputOracle existingL2OO = L2OutputOracle(l2OOProxy);
        uint256 oldSubmissionInterval = existingL2OO.SUBMISSION_INTERVAL();
        uint256 oldL2BlockTime = existingL2OO.L2_BLOCK_TIME();
        address oldProposer = existingL2OO.PROPOSER();
        uint256 oldFinalizationPeriodSeconds = existingL2OO.FINALIZATION_PERIOD_SECONDS();

        console.log(oldSubmissionInterval);
        console.log(oldL2BlockTime);
        console.log(oldProposer);
        console.log(oldFinalizationPeriodSeconds);
        console.log(existingL2OO.CHALLENGER());

        // Deploy L2OutputOracle new implementation with new challenger
        vm.broadcast(deployer);
        L2OutputOracle l2OutputOracleImpl = new L2OutputOracle({
            _submissionInterval: oldSubmissionInterval,
            _l2BlockTime: oldL2BlockTime,
            _startingBlockNumber: 0,
            _startingTimestamp: 0,
            _proposer: oldProposer,
            _challenger: challenger,
            _finalizationPeriodSeconds: oldFinalizationPeriodSeconds            
        });

        require(l2OutputOracleImpl.CHALLENGER() == challenger, "Deploy: l2OutputOracle challenger is incorrect");

        require(l2OutputOracleImpl.SUBMISSION_INTERVAL() == oldSubmissionInterval, "Deploy: l2OutputOracle submissionInterval is incorrect");
        require(l2OutputOracleImpl.L2_BLOCK_TIME() == oldL2BlockTime, "Deploy: l2OutputOracle l2BlockTime is incorrect");
        require(l2OutputOracleImpl.startingBlockNumber() == 0, "Deploy: l2OutputOracle startingBlockNumber is incorrect");
        require(l2OutputOracleImpl.startingTimestamp() == 0, "Deploy: l2OutputOracle startingTimestamp is incorrect");
        require(l2OutputOracleImpl.PROPOSER() == oldProposer, "Deploy: l2OutputOracle proposer is incorrect");
        require(l2OutputOracleImpl.FINALIZATION_PERIOD_SECONDS() == oldFinalizationPeriodSeconds, "Deploy: l2OutputOracle finalizationPeriodSeconds is incorrect");
    }
}
