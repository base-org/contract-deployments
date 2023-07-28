// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import { console } from "forge-std/console.sol";
import { Script } from "forge-std/Script.sol";
import { Proxy } from "@eth-optimism-bedrock/contracts/universal/Proxy.sol";
import { FeeDisburser } from "@base-contracts/src/revenue-share/FeeDisburser.sol";

contract DeployFeeDisburser is Script {
    function run() public {
        address deployer = vm.envAddress("DEPLOYER");
        address admin = vm.envAddress("L2_ADMIN");
        
        address payable optimismWallet = payable(vm.envAddress("OPTIMISM_WALLET"));
        address l1Wallet = vm.envAddress("L1_WALLET");
        uint256 feeDisbursmentInterval = vm.envUint("FEE_DISBURSAL_INTERVAL");
        
        vm.broadcast(deployer);
        FeeDisburser feeDisburserImpl = new FeeDisburser(optimismWallet, l1Wallet, feeDisbursmentInterval);
        require(feeDisburserImpl.OPTIMISM_WALLET() == optimismWallet, "DeployFeeDisburser: optimism wallet address incorrect");
        require(feeDisburserImpl.L1_WALLET() == l1Wallet, "DeployFeeDisburser: l1 wallet address incorrect");
        require(feeDisburserImpl.FEE_DISBURSEMENT_INTERVAL() == feeDisbursmentInterval, "DeployFeeDisburser: fee disbursement interval incorrect");
        
        vm.broadcast(deployer);
        Proxy proxy = new Proxy(deployer);
        FeeDisburser feeDisburser = FeeDisburser(payable(address(proxy)));

        vm.broadcast(deployer);
        proxy.upgradeTo(address(feeDisburserImpl));
        require(feeDisburser.OPTIMISM_WALLET() == optimismWallet, "DeployFeeDisburser: optimism wallet address incorrect");
        
        vm.broadcast(deployer);
        proxy.changeAdmin(admin);
        vm.prank(address(0));
        require(proxy.admin() == admin, "DeployBalanceTracker: proxy admin transfer failed");
    }
}
