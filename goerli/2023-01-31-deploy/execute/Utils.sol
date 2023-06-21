pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/StdJson.sol";

contract Utils is Script {
    using stdJson for string;

    struct DeployBedrockConfig {
        address batchSenderAddress;
        address controller;
        address deployerAddress;
        address finalSystemOwner;
        uint256 finalizationPeriodSeconds;
        uint256 gasPriceOracleOverhead;
        uint256 gasPriceOracleScalar;
        uint256 l2BlockTime;
        uint64 l2GenesisBlockGasLimit;
        address l2OutputOracleChallenger;
        address l2OutputOracleProposer;
        uint256 l2OutputOracleStartingBlockNumber;
        uint256 l2OutputOracleSubmissionInterval;
        address p2pSequencerAddress;
    }

    function getDeployBedrockConfig(string memory network) external view returns(DeployBedrockConfig memory) {
        string memory root = vm.projectRoot();
        string memory path = string.concat(root, "deployed/foundry-config.json");
        string memory json = vm.readFile(path);
        bytes memory deployBedrockConfigRaw = json.parseRaw(".deployConfig");
        return abi.decode(deployBedrockConfigRaw, (DeployBedrockConfig));
    }
}
