// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import { console } from "forge-std/console.sol";

import { IMulticall3 } from "forge-std/interfaces/IMulticall3.sol";

import { Proxy } from "@eth-optimism-bedrock/contracts/universal/Proxy.sol";

import { MultisigBuilder } from "@base-contracts/script/universal/MultisigBuilder.sol";
import { FeeDisburser } from "@base-contracts/src/revenue-share/FeeDisburser.sol";

contract UpgradeToFeeDisburser is MultisigBuilder {
    address payable internal FEE_DISBURSER_PROXY = payable(vm.envAddress("FEE_DISBURSER_PROXY"));
    address payable internal FEE_DISBURSER_IMPL = payable(vm.envAddress("FEE_DISBURSER_IMPL"));
    address internal OPTIMISM_WALLET = vm.envAddress("OPTIMISM_WALLET");
    address internal CB_SAFE_ADDR = vm.envAddress("CB_SAFE_ADDR");

    function _buildCalls() internal override view returns (IMulticall3.Call3[] memory) {

        console.log("Fee Diburser Proxy %s", FEE_DISBURSER_PROXY);
        console.log("Fee Diburser Impl %s", FEE_DISBURSER_IMPL);
        console.log("Optimism Wallet %s", OPTIMISM_WALLET);
        console.log("CB_SAFE_ADDR %s", CB_SAFE_ADDR);

        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](1);

        ///
        // FEE DISBURSER PROXY UPGRADE TO FEE DISBURSER IMPLEMENTATION CALL
        ///
        calls[0] = IMulticall3.Call3({
            target: FEE_DISBURSER_PROXY,
            allowFailure: false,
            callData: abi.encodeCall(
                Proxy.upgradeTo,
                (
                    FEE_DISBURSER_IMPL
                )
            )
        });

        return calls;
    }

    function _ownerSafe() internal override view returns (address) {
        return CB_SAFE_ADDR;
    }

    function _postCheck() internal override view {
        require(
            FeeDisburser(FEE_DISBURSER_PROXY).OPTIMISM_WALLET() == OPTIMISM_WALLET,
            "UpgradeToFeeDisburser: FeeDisburser incorrect Optimism Wallet"
        );
    }
}
