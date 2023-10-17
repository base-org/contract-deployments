// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@eth-optimism-bedrock/src/universal/ProxyAdmin.sol";
import "@base-contracts/script/universal/NestedMultisigBuilder.sol";
import "@eth-optimism-bedrock/src/libraries/Predeploys.sol";

contract UpgradeToL2OO is NestedMultisigBuilder {
    address internal PROXY_ADMIN_CONTRACT = Predeploys.PROXY_ADMIN;
    address internal PROXY_ADMIN_OWNER = vm.envAddress("L2_NESTED_SAFE");
    address internal L2_OUTPUT_ORACLE_PROXY = vm.envAddress("L2_OUTPUT_ORACLE_PROXY");
    address internal L2_OUTPUT_ORACLE_IMPLEMENTATION = vm.envAddress("L2_OUTPUT_ORACLE_IMPLEMENTATION");

    function _postCheck() internal override view {
        ProxyAdmin proxyAdmin = ProxyAdmin(PROXY_ADMIN_CONTRACT);
        require(proxyAdmin.getProxyImplementation(L2_OUTPUT_ORACLE_PROXY).codehash == L2_OUTPUT_ORACLE_IMPLEMENTATION.codehash);
    }

    function _buildCalls() internal override view returns (IMulticall3.Call3[] memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](1);

        calls[0] = IMulticall3.Call3({
            target: PROXY_ADMIN_CONTRACT,
            allowFailure: false,
            callData: abi.encodeCall(
                ProxyAdmin.upgrade,
                (payable(L2_OUTPUT_ORACLE_PROXY), L2_OUTPUT_ORACLE_IMPLEMENTATION)
            )
        });

        return calls;
    }

    function _ownerSafe() internal override view returns (address) {
        return PROXY_ADMIN_OWNER;
    }
}