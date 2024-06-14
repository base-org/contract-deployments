// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "forge-std/Script.sol";
import "@base-contracts/script/universal/MultisigBuilder.sol";
import {DelayedWETH,SuperchainConfig} from "@eth-optimism-bedrock/src/dispute/weth/DelayedWETH.sol";
import {DisputeGameFactory} from "@eth-optimism-bedrock/src/dispute/DisputeGameFactory.sol";
import {ProxyAdmin} from "@eth-optimism-bedrock/src/universal/ProxyAdmin.sol";

contract InitializeFaultProofProxies is MultisigBuilder {
    address internal PROXY_ADMIN = vm.envAddress("PROXY_ADMIN");
    address internal PROXY_ADMIN_OWNER = vm.envAddress("PROXY_ADMIN_OWNER");
    address internal SUPERCHAIN_CONFIG_PROXY = vm.envAddress("SUPERCHAIN_CONFIG_PROXY");

    address internal DISPUTE_GAME_FACTORY_PROXY = vm.envAddress("DISPUTE_GAME_FACTORY_PROXY");
    address internal DISPUTE_GAME_FACTORY_IMPLEMENTATION = vm.envAddress("DISPUTE_GAME_FACTORY_IMPLEMENTATION");

    address internal DELAYED_WETH_PROXY = vm.envAddress("DELAYED_WETH_PROXY");
    address internal DELAYED_WETH_IMPLEMENTATION = vm.envAddress("DELAYED_WETH_IMPLEMENTATION");

    /**
     * @notice Follow up assertions to ensure that the script ran to completion.
     */
    function _postCheck(Vm.AccountAccess[] memory, SimulationPayload memory) internal view override {
        // 1. Check DisputeGameFactoryProxy
        DisputeGameFactory factory = DisputeGameFactory(DISPUTE_GAME_FACTORY_PROXY);
        console.log("DisputeGameFactory version: %s", factory.version());
        require(factory.owner() == PROXY_ADMIN_OWNER);

        // 2. Check DelayedWETHProxy
        DelayedWETH weth = DelayedWETH(payable(DELAYED_WETH_PROXY));
        console.log("DelayedWETH version: %s", weth.version());
        require(weth.owner() == PROXY_ADMIN_OWNER);
        // https://github.com/ethereum-optimism/optimism/blob/3aeb6bdd3efe798713098f890359513eaaa91522/packages/contracts-bedrock/deploy-config/mainnet.json#L52
        require(weth.delay() == 604800);
    }

    /**
     * @notice Creates the calldata
     */
    function _buildCalls() internal view override returns (IMulticall3.Call3[] memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](2);

        // 1. Initialize DisputeGameFactoryProxy
        calls[0] = IMulticall3.Call3({
            target: PROXY_ADMIN,
            allowFailure: false,
            callData: abi.encodeCall(
                ProxyAdmin.upgradeAndCall,
                (
                    payable(DISPUTE_GAME_FACTORY_PROXY),
                    DISPUTE_GAME_FACTORY_IMPLEMENTATION,
                    abi.encodeCall(DisputeGameFactory.initialize, (PROXY_ADMIN_OWNER))
                )
            )
        });

        // 2. Initialize DelayedWETHProxy
        calls[1] = IMulticall3.Call3({
            target: PROXY_ADMIN,
            allowFailure: false,
            callData: abi.encodeCall(
                ProxyAdmin.upgradeAndCall,
                (
                    payable(DELAYED_WETH_PROXY),
                    DELAYED_WETH_IMPLEMENTATION,
                    abi.encodeCall(DelayedWETH.initialize, (PROXY_ADMIN_OWNER, SuperchainConfig(SUPERCHAIN_CONFIG_PROXY)))
                )
            )
        });

        return calls;
    }

    /**
     * @notice Returns the safe address to execute the transaction from
     */
    function _ownerSafe() internal override view returns (address) {
        return PROXY_ADMIN_OWNER;
    }
}
