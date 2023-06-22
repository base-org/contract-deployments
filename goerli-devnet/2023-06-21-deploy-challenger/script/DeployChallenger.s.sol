// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import { Challenger1of2 } from "@base-contracts/src/Challenger1of2.sol";

contract DeployChallenger is Script {
    function run(address signer1, address signer2, address l2OutputOracleProxy) public {
        Challenger1of2 challenger1of2 = new Challenger1of2(signer1, signer2, l2OutputOracleProxy);
        require(challenger1of2.OP_SIGNER() == signer1, "OP_SIGNER not set correctly");
        require(challenger1of2.OTHER_SIGNER() == signer2, "OTHER_SIGNER not set correctly");
        require(challenger1of2.L2_OUTPUT_ORACLE_PROXY() == l2OutputOracleProxy, "L2_OUTPUT_ORACLE_PROXY not set correctly");
        console.log(address(challenger1of2));
    }
}
