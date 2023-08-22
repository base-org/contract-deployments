// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "forge-std/Script.sol";
import { Test } from "@base-contracts/src/Test.sol";

contract TestTxs is Script {
    function run(address keyToTest) public {
        vm.broadcast(keyToTest);
        Test test = new Test();

        vm.broadcast(keyToTest);
        test.setNumber(100);

        vm.broadcast(keyToTest);
        test.increment();
    }
}
