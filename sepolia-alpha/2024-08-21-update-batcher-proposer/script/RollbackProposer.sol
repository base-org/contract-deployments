// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@eth-optimism-bedrock/src/universal/ProxyAdmin.sol";
import {L2OutputOracle} from "@eth-optimism-bedrock/src/L1/L2OutputOracle.sol";
import "forge-std/Script.sol";

contract RollbackProposer is Script {
    address internal OLD_PROPOSER = vm.envAddress("OLD_PROPOSER");
    address internal PROXY_ADMIN = vm.envAddress("L1_PROXY_ADMIN");
    address internal PROXY_ADMIN_OWNER = vm.envAddress("PROXY_ADMIN_OWNER");
    address internal L2_OUTPUT_ORACLE_PROXY = vm.envAddress("L2_OUTPUT_ORACLE_PROXY");
    address internal ROLLBACK_L2_OUTPUT_PROPOSER_IMPL = vm.envAddress("ROLLBACK_L2_OUTPUT_PROPOSER_IMPL");

    function run() public {
        L2OutputOracle l2OOProxy = L2OutputOracle(L2_OUTPUT_ORACLE_PROXY);
        ProxyAdmin proxyAdmin = ProxyAdmin(PROXY_ADMIN);
        // vm.prank(PROXY_ADMIN_OWNER);
        proxyAdmin.upgrade(payable(L2_OUTPUT_ORACLE_PROXY), ROLLBACK_L2_OUTPUT_PROPOSER_IMPL);
        require(proxyAdmin.getProxyImplementation(L2_OUTPUT_ORACLE_PROXY).codehash == ROLLBACK_L2_OUTPUT_PROPOSER_IMPL.codehash, "Rollback Deploy: l2OutputOracle codehash is incorrect");
        require(l2OOProxy.PROPOSER() == OLD_PROPOSER, "Rollback Deploy: l2OutputOracle proposer is incorrect");
    }
}