// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "forge-std/Script.sol";

contract SomeScript is Script {
    function setUp() public {}

    function run() public {
        RunThis runThis = new RunThis();
        runThis.run();
    }
}
