// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/StdJson.sol";
import "@base-contracts/script/upgrade/l2/PostSherlockL2.s.sol";

contract RunPostSherlockL2 is Script {
    function run(uint256 _l2ChainId, address _safe) public {
        PostSherlockL2 postSherlockL2 = new PostSherlockL2(_l2ChainId);
        postSherlockL2.setUp();
        postSherlockL2.run(_safe);
    }
}