// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import { console } from "forge-std/console.sol";
import { Script } from "forge-std/Script.sol";
import { Proxy } from "@eth-optimism-bedrock/contracts/universal/Proxy.sol";
import { BalanceTracker } from "@base-contracts/src/revenue-share/BalanceTracker.sol";

contract DeployBalanceTracker is Script {
    address payable proposerAddress = payable(vm.envAddress("PROPOSER_ADDRESS"));
    address payable batchSenderAddress = payable(vm.envAddress("BATCH_SENDER_ADDRESS"));
    uint256 proposerTargetBalance = vm.envUint("PROPOSER_TARGET_BALANCE");
    uint256 batchSenderTargetBalance = vm.envUint("BATCH_SENDER_TARGET_BALANCE");
    
    address payable[] systemAddresses = [proposerAddress, batchSenderAddress];
    uint256[] targetBalances = [proposerTargetBalance, batchSenderTargetBalance];
    
    function run() public {
        address deployer = vm.envAddress("DEPLOYER");
        address admin = vm.envAddress("L1_ADMIN");
        
        address payable profitWallet = payable(vm.envAddress("PROFIT_WALLET"));
        
        
        vm.broadcast(deployer);
        BalanceTracker balanceTrackerImpl = new BalanceTracker(profitWallet);
        require(balanceTrackerImpl.PROFIT_WALLET() == profitWallet, "DeployBalanceTracker: profit wallet address incorrect");
        
        vm.broadcast(deployer);
        Proxy proxy = new Proxy(deployer);
        BalanceTracker balanceTracker = BalanceTracker(payable(address(proxy)));

        bytes memory initializeCall = abi.encodeCall(
            BalanceTracker.initialize,
            (
                systemAddresses,
                targetBalances
            )
        );

        vm.broadcast(deployer);
        proxy.upgradeToAndCall(address(balanceTrackerImpl), initializeCall);
        require(balanceTracker.PROFIT_WALLET() == profitWallet, "DeployBalanceTracker: profit wallet address incorrect");
        require(balanceTracker.systemAddresses(0) == proposerAddress, "DeployBalanceTracker: proposer system address incorrect");
        require(balanceTracker.systemAddresses(1) == batchSenderAddress, "DeployBalanceTracker: batch sender system address incorrect");
        require(balanceTracker.targetBalances(0) == proposerTargetBalance, "DeployBalanceTracker: proposer target balance incorrect");
        require(balanceTracker.targetBalances(1) == batchSenderTargetBalance, "DeployBalanceTracker: batch sender target balance incorrect");
        
        vm.broadcast(deployer);
        proxy.changeAdmin(admin);
        vm.prank(address(0));
        require(proxy.admin() == admin, "DeployBalanceTracker: proxy admin transfer failed");
    }
}
