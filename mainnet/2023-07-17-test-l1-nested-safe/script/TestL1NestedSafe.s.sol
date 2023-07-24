// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {
    OwnableUpgradeable
} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@base-contracts/script/universal/NestedMultisigBuilder.sol";
import "@eth-optimism-bedrock/contracts/universal/ProxyAdmin.sol";


contract TestL1NestedSafe is NestedMultisigBuilder {
    // ProxyAdminContract owned by the Nested L1 Safe
    address constant internal PROXY_ADMIN_CONTRACT = 0x8735F6e34c3C97B2e1a1a9C9BbBf0D9b290c4151;
    // An example proxy contract which originally points to the old implementation
    address constant internal PROXY_CONTRACT = 0xB49D362028A668f5f29338361453D56BEB76d9F5;
    // Existing implementation contract for the proxy
    address constant internal OLD_IMPLEMENTATION = 0x4A466E4a2b5106bD7f2d3B39d35ded2ACDF491a2;
    // Implementation contract we want to upgrade to
    address constant internal NEW_IMPLEMENTATION = 0xEACccF3894Ef189A29a557F1B533932bf1ad8d11;
    // Safe we're testing, which is the owner of the Proxy contract
    address constant internal NESTED_L1_SAFE = 0x7bB41C3008B3f03FE483B28b8DB90e19Cf07595c;

    function _postCheck() internal override view {
        ProxyAdmin proxyAdmin = ProxyAdmin(PROXY_ADMIN_CONTRACT);

        // Check contract was upgraded
        require(
            proxyAdmin.getProxyImplementation(PROXY_CONTRACT) == NEW_IMPLEMENTATION,
            "TestL1NestedSafe: implementation did not get set"
        );
    }

    function _buildCalls() internal override view returns (IMulticall3.Call3[] memory) {
        ProxyAdmin proxyAdmin = ProxyAdmin(PROXY_ADMIN_CONTRACT);
        require(
            proxyAdmin.getProxyImplementation(PROXY_CONTRACT) == OLD_IMPLEMENTATION,
            "TestL1NestedSafe: implementation did not get set"
        );

        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](1);

        // Upgrade contract implementation
        calls[0] = IMulticall3.Call3({
            target: PROXY_ADMIN_CONTRACT,
            allowFailure: false,
            callData: abi.encodeCall(
                ProxyAdmin.upgrade,
                (payable(PROXY_CONTRACT), NEW_IMPLEMENTATION)
            )
        });

        return calls;
    }

    function _ownerSafe() internal override view returns (address) {
        return NESTED_L1_SAFE;
    }
}
