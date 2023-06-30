// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@eth-optimism-bedrock/contracts/universal/ProxyAdmin.sol";
import "@base-contracts/script/universal/NestedMultisigBuilder.sol";

contract UpgradeL2OutputOracle is NestedMultisigBuilder {
    address constant internal PROXY_ADMIN_CONTRACT = 0x4d56E97228bBF10DcB2ED7E8F455c57AbE247404;
    address constant internal PROXY_ADMIN_OWNER = 0xCDdEb1F77Cbc9BD2Bd07aD5808CE6108EB07DF89; // Nested Safe addr
    address constant internal L2_OUTPUT_ORACLE_PROXY = 0x805fbEDB43E814b2216ce6926A0A19bdeDb0C8Cd;
    address constant internal NEW_IMPLEMENTATION = 0x18CfD51a12543a7a1e5Ea3aEaa8fDD32e92F35E5;

    function _postCheck() internal override view {
        ProxyAdmin proxyAdmin = ProxyAdmin(PROXY_ADMIN_CONTRACT);
        require(proxyAdmin.getProxyImplementation(L2_OUTPUT_ORACLE_PROXY).codehash == NEW_IMPLEMENTATION.codehash);
    }

    function _buildCalls() internal override view returns (IMulticall3.Call3[] memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](1);

        calls[0] = IMulticall3.Call3({
            target: PROXY_ADMIN_CONTRACT,
            allowFailure: false,
            callData: abi.encodeCall(
                ProxyAdmin.upgrade,
                (payable(L2_OUTPUT_ORACLE_PROXY), NEW_IMPLEMENTATION)
            )
        });

        return calls;
    }

    function _ownerSafe() internal override view returns (address) {
        return PROXY_ADMIN_OWNER;
    }
}