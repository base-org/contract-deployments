// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import { SetGasLimitBuilder } from "@base-contracts/script/deploy/l1/SetGasLimitBuilder.sol";

contract Rollback is SetGasLimitBuilder {
    uint64 internal OLD_GAS_LIMIT = uint64(vm.envUint("OLD_GAS_LIMIT"));
    uint64 internal NEW_GAS_LIMIT = uint64(vm.envUint("NEW_GAS_LIMIT"));

    function _fromGasLimit() internal view override returns (uint64) {
        return NEW_GAS_LIMIT;
    }

    function _toGasLimit() internal view override returns (uint64) {
        return OLD_GAS_LIMIT;
    }

    function _nonceOffset() internal pure override returns (uint64) {
        return 1;
    }
}
