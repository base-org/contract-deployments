// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "forge-std/Script.sol";
import "@eth-optimism-bedrock/contracts/universal/ProxyAdmin.sol";
import "@eth-optimism-bedrock/contracts/universal/OptimismMintableERC20Factory.sol";


contract DeployTestProxy is Script {
    function run(address deployer, address safeToTest) public {
        vm.broadcast(deployer);
        ProxyAdmin proxyAdmin = new ProxyAdmin({
            _owner: deployer
        });
        require(proxyAdmin.owner() == deployer, "DeployTestProxy: proxyAdmin owner is incorrect");

        // Deploy proxy contract and implementation which we will then upgrade
        vm.broadcast(deployer);
        Proxy proxy = new Proxy({
            _admin: address(proxyAdmin)
        });
        vm.prank(address(0));
        require(proxy.admin() == address(proxyAdmin), "DeployTestProxy: admin is incorrect");

        vm.broadcast(deployer);
        OptimismMintableERC20Factory implementation = new OptimismMintableERC20Factory(address(0));
        vm.broadcast(deployer);
        OptimismMintableERC20Factory implementation2 = new OptimismMintableERC20Factory(address(0));

        vm.broadcast(deployer);
        proxyAdmin.upgrade({
            _proxy: payable(proxy),
            _implementation: address(implementation)
        });
        require(
            proxyAdmin.getProxyImplementation(address(proxy)) == address(implementation),
            "DeployTestProxy: implementation did not get set"
        );

        vm.broadcast(deployer);
        proxyAdmin.transferOwnership(safeToTest);
        require(proxyAdmin.owner() == safeToTest, "DeployTestProxy: proxyAdmin owner did not transfer correctly");

        console.log("DeployTestProxy: Deployed Addresses");
        console.log("ProxyAdmin: ", address(proxyAdmin));
        console.log("Proxy: ", address(proxy));
        console.log("Implementation: ", address(implementation));
        console.log("Implementation2: ", address(implementation2));
    }
}