// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@eth-optimism-bedrock/src/universal/ProxyAdmin.sol";
import "@base-contracts/script/universal/NestedMultisigBuilder.sol";
import "@eth-optimism-bedrock/src/libraries/Predeploys.sol";

contract UpgradeToEASAndTF is NestedMultisigBuilder {
    address internal PROXY_ADMIN_CONTRACT = Predeploys.PROXY_ADMIN;
    address internal PROXY_ADMIN_OWNER = vm.envAddress("L2_NESTED_SAFE");
    address internal SCHEMA_REGISTRY_PROXY = Predeploys.SCHEMA_REGISTRY;
    address internal EAS_PROXY = Predeploys.EAS;
    address internal ERC20_PROXY = vm.envAddress("ERC20_PROXY_ADDRESS");
    address internal ERC721_PROXY = vm.envAddress("ERC721_PROXY_ADDRESS");
    address internal SCHEMA_REGISTRY_IMPLEMENTATION = vm.envAddress("REGISTRY_IMPL_ADDRESS");
    address internal EAS_IMPLEMENTATION = vm.envAddress("EAS_IMPL_ADDRESS");
    address internal ERC20_IMPLEMENTATION = vm.envAddress("ERC20_IMPL_ADDRESS");
    address internal ERC721_IMPLEMENTATION = vm.envAddress("ERC721_IMPL_ADDRESS");

    function _postCheck() internal override view {
        ProxyAdmin proxyAdmin = ProxyAdmin(PROXY_ADMIN_CONTRACT);
        require(proxyAdmin.getProxyImplementation(SCHEMA_REGISTRY_PROXY).codehash == SCHEMA_REGISTRY_IMPLEMENTATION.codehash);
        require(proxyAdmin.getProxyImplementation(EAS_PROXY).codehash == EAS_IMPLEMENTATION.codehash);
        require(proxyAdmin.getProxyImplementation(ERC20_PROXY).codehash == ERC20_IMPLEMENTATION.codehash);  
        require(proxyAdmin.getProxyImplementation(ERC721_PROXY).codehash == ERC721_IMPLEMENTATION.codehash);
    }

    function _buildCalls() internal override view returns (IMulticall3.Call3[] memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](2);

        calls[0] = IMulticall3.Call3({
            target: PROXY_ADMIN_CONTRACT,
            allowFailure: false,
            callData: abi.encodeCall(
                ProxyAdmin.upgrade,
                (payable(SCHEMA_REGISTRY_PROXY), SCHEMA_REGISTRY_IMPLEMENTATION)
            )
        });

        calls[1] = IMulticall3.Call3({
            target: PROXY_ADMIN_CONTRACT,
            allowFailure: false,
            callData: abi.encodeCall(
                ProxyAdmin.upgrade,
                (payable(EAS_PROXY), EAS_IMPLEMENTATION)
            )
        });

        calls[2] = IMulticall3.Call3({
            target: PROXY_ADMIN_CONTRACT,
            allowFailure: false,
            callData: abi.encodeCall(
                ProxyAdmin.upgrade,
                (payable(ERC20_PROXY), ERC20_IMPLEMENTATION)
            )
        });

        calls[3] = IMulticall3.Call3({
            target: PROXY_ADMIN_CONTRACT,
            allowFailure: false,
            callData: abi.encodeCall(
                ProxyAdmin.upgrade,
                (payable(ERC721_PROXY), ERC721_IMPLEMENTATION)
            )
        });

        return calls;
    }

    function _ownerSafe() internal override view returns (address) {
        return PROXY_ADMIN_OWNER;
    }
}