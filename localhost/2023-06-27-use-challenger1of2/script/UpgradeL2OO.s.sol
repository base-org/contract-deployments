// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@eth-optimism-bedrock/contracts/universal/ProxyAdmin.sol";
import "@base-contracts/script/universal/MultisigBuilder.sol";

contract UpgradeL2OutputOracle is MultisigBuilder {
    address constant internal PROXY_ADMIN_CONTRACT = 0x5FbDB2315678afecb367f032d93F642f64180aa3;
    address constant internal PROXY_ADMIN_OWNER = 0x41715Dd88D95c3c80248f19DAcE21015346069b8; // Nested Safe addr
    address constant internal L2_OUTPUT_ORACLE_PROXY = 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9;
    address constant internal NEW_IMPLEMENTATION = 0x851356ae760d987E095750cCeb3bC6014560891C;

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