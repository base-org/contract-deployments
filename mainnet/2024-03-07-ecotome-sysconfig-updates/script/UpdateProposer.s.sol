// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@eth-optimism-bedrock/src/universal/ProxyAdmin.sol";
import "@base-contracts/script/universal/NestedMultisigBuilder.sol";

contract UpdateProposer is NestedMultisigBuilder {
    // TODO: this assumes a new L2OutputOracle implementation contract has already been deployed. See SetupNewProposer.s.sol.

    address internal PROXY_ADMIN_CONTRACT = vm.envAddress("L1_PROXY_ADMIN"); // TODO: define L1_PROXY_ADMIN=xxx in the .env file
    address internal PROXY_ADMIN_OWNER = vm.envAddress("L1_NESTED_SAFE"); // TODO: define L1_NESTED_SAFE=xxx in the .env file
    address internal L2_OUTPUT_PROPOSER = vm.envAddress("L2_OUTPUT_PROPOSER"); // TODO: define L2_OUTPUT_PROPOSER=xxx in the .env file
    address internal L2_OUTPUT_PROPOSER_NEW_IMPL = vm.envAddress("L2_OUTPUT_PROPOSER_NEW_IMPL"); // TODO: define L2_OUTPUT_PROPOSER_NEW_IMPL=xxx in the .env file

    function _postCheck() internal override view {
        ProxyAdmin proxyAdmin = ProxyAdmin(PROXY_ADMIN_CONTRACT);
        require(proxyAdmin.getProxyImplementation(L2_OUTPUT_PROPOSER).codehash == L2_OUTPUT_PROPOSER_NEW_IMPL.codehash);
    }

    function _buildCalls() internal override view returns (IMulticall3.Call3[] memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](1);

        calls[0] = IMulticall3.Call3({
            target: PROXY_ADMIN_CONTRACT,
            allowFailure: false,
            callData: abi.encodeCall(
                ProxyAdmin.upgrade,
                (payable(L2_OUTPUT_PROPOSER), L2_OUTPUT_PROPOSER_NEW_IMPL)
            )
        });

        return calls;
    }

    function _ownerSafe() internal override view returns (address) {
        return PROXY_ADMIN_OWNER;
    }
}