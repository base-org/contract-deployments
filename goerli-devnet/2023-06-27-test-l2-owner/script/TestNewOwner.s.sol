// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@eth-optimism-bedrock/contracts/universal/ProxyAdmin.sol";
import "@base-contracts/script/universal/NestedMultisigBuilder.sol";

// We test a new ProxyAdminOwner by upgrading a contract it should now own. To minimize risk,
// this is an "upgrade" where we set the implementation address to the same address. So no
// state should actually change
contract TestNewOwner is NestedMultisigBuilder {
    address constant internal PROXY_ADMIN_CONTRACT = 0x4200000000000000000000000000000000000018; 
    address constant internal L2_OWNER = 0xf71a498086d00843d7754964B27dd7198a16Ee7F;
    address constant internal L1_BLOCK_PROXY = 0x4200000000000000000000000000000000000015;
    address constant internal IMPLEMENTATION_ADDR = 0x6309F4Da2449726429d8880F9b6E883bd2f62042;

    function _postCheck() internal override view {
        // perform post execution checks
    }

    function _buildCalls() internal override view returns (IMulticall3.Call3[] memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](1);

        calls[0] = IMulticall3.Call3({
            target: PROXY_ADMIN_CONTRACT,
            allowFailure: false,
            callData: abi.encodeCall(
                ProxyAdmin.upgrade,
                (payable(L1_BLOCK_PROXY), IMPLEMENTATION_ADDR)
            )
        });

        return calls;
    }

    function _ownerSafe() internal override view returns (address) {
        return L2_OWNER;
    }
}