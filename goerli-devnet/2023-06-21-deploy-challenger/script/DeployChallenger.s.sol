// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import { Challenger1of2 } from "@base-contracts/src/Challenger1of2.sol";

contract DeployChallenger is Script {
    function run(address signer1, address signer2, address l2OutputOracleProxy) public {
        Challenger1of2 challenger = new Challenger1of2(signer1, signer2, l2OutputOracleProxy);
        console.log(address(challenger));
    }
}
