// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@eth-optimism-bedrock/contracts/universal/ProxyAdmin.sol";
import "@base-contracts/script/universal/NestedMultisigBuilder.sol";

contract UpgradeL2OutputOracle is NestedMultisigBuilder {
    address constant internal PROXY_ADMIN_CONTRACT = 0xbc0Fc544736b7d610D9b05F31B182C8154BEf336;
    address constant internal PROXY_ADMIN_OWNER = 0x444b8C3E4eA49cE15A93D96AfA83D421F6049524; // Nested Safe addr
    address constant internal L2_OUTPUT_ORACLE_PROXY = 0x2A35891ff30313CcFa6CE88dcf3858bb075A2298;
    address constant internal NEW_IMPLEMENTATION = 0x0849100Ad5d0F1535775550740BADDed5C5DbcE0;

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