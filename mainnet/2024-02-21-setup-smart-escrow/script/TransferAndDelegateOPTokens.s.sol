// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@base-contracts/script/universal/NestedMultisigBuilder.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@agora/structs/RulesV3.sol";
import "@agora/structs/AllowanceType.sol";
import "@agora/alligator/AlligatorOP_V5.sol";
// import {SafeTransferLib} from "solady/utils/SafeTransferLib.sol";


contract TransferAndDelegateOPTokens is NestedMultisigBuilder {
    using SafeERC20 for IERC20;
    // using ERC20Votes for IERC20;

    address internal NESTED_SAFE = vm.envAddress("NESTED_SAFE");
    IERC20 internal OP_TOKEN = IERC20(vm.envAddress("OP_TOKEN"));
    address internal SMART_ESCROW = vm.envAddress("SMART_ESCROW_CONTRACT");
    address internal ALLIGATOR_PROXY = vm.envAddress("ALLIGATOR_PROXY"); // Agora address which will allow for subdeletation
    address internal CB_GOVERNANCE_WALLET = vm.envAddress("CB_GOVERNANCE_WALLET");

    uint256 internal COLLAB_GRANT_TOKENS = vm.envUint("COLLAB_GRANT_TOKENS");
    uint256 internal UPFRONT_GRANT_TOKENS = vm.envUint("UPFRONT_GRANT_TOKENS");

    function _postCheck() internal override view {
        // TODO
    }

    function _buildCalls() internal override view returns (IMulticall3.Call3[] memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](3);

        // Transfer collaboration grant tokens to smart escrow
        calls[0] = IMulticall3.Call3({
            target: address(this),
            allowFailure: false,
            callData: abi.encodeCall(
                this.transferOPTokens, ()
            )
        });
        // Delegate governance tokens for initial grant to Agora's Alligator proxy, which will allow for subdelegations
        calls[1] = IMulticall3.Call3({
            target: address(OP_TOKEN),
            allowFailure: false,
            callData: abi.encodeCall(
                ERC20Votes.delegate,
                (ALLIGATOR_PROXY)
            )
        });

        SubdelegationRules memory subdelegationRules = SubdelegationRules({
            maxRedelegations: 2,
            blocksBeforeVoteCloses: 0,
            notValidBefore: 0,
            notValidAfter: 0,
            customRule: address(0),
            allowanceType: AllowanceType.Absolute,
            allowance: 1e18
        });

        // Delegate the tokens to the Coinbase owned address
        calls[2] = IMulticall3.Call3({
            target: ALLIGATOR_PROXY,
            allowFailure: false,
            callData: abi.encodeCall(
                AlligatorOPV5.subdelegate,
                (CB_GOVERNANCE_WALLET,
                subdelegationRules)
            )
        });

        return calls;
    }

    function transferOPTokens() public {
        OP_TOKEN.safeTransfer(SMART_ESCROW, COLLAB_GRANT_TOKENS);
    }

    function _ownerSafe() internal override view returns (address) {
        return NESTED_SAFE;
    }
}
