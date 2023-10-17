// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "forge-std/Script.sol";
import "@eth-optimism-bedrock/src/universal/OptimismMintableERC721Factory.sol";
import "@eth-optimism-bedrock/src/universal/OptimismMintableERC20Factory.sol";

contract DeployUpgradedTokenFactory is Script {
    address internal _deployer = vm.envAddress("DEPLOYER");
    address erc20_proxy = vm.envAddress("ERC20_PROXY");
    address erc721_proxy = vm.envAddress("ERC721_PROXY");

    function run() public {
        
        // OptimismMintableERC20Factory erc20 = OptimismMintableERC20Factory(erc20_proxy);
        // address oldBridge = erc20.BRIDGE();

        vm.broadcast(_deployer);
        OptimismMintableERC20Factory erc20Implentation = new OptimismMintableERC20Factory();
       
        OptimismMintableERC721Factory erc721 = OptimismMintableERC721Factory(erc721_proxy);
        address oldBridge721 = erc721.BRIDGE();
        uint256 oldRemoteChainID = erc721.REMOTE_CHAIN_ID();

        vm.broadcast(_deployer);
        OptimismMintableERC721Factory erc721Implentation = new OptimismMintableERC721Factory(oldBridge721, oldRemoteChainID);

        console.logAddress(_deployer);
        console.logAddress(address(erc20Implentation));
        console.logAddress(address(erc721Implentation));
    }
}