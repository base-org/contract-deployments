// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@base-contracts/script/universal/NestedMultisigBuilder.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@agora/structs/RulesV3.sol";
import "@agora/structs/AllowanceType.sol";
import "@agora/alligator/AlligatorOP_V5.sol";

contract TransferOPTokens is NestedMultisigBuilder {
    using SafeERC20 for IERC20;
    using ERC20Votes for IERC20;

    address constant internal NESTED_SAFE = vm.envAddress("NESTED_SAFE");
    IERC20 public constant OP_TOKEN = IERC20(vm.envAddress("OP_TOKEN"));
    address public constant SMART_ESCROW = vm.envAddress("SMART_ESCROW_CONTRACT");
    address public constant ALLIGATOR_PROXY = vm.envAddress("ALLIGATOR_PROXY"); // Agora address which will allow for subdeletation
    address public constant CB_GOVERNANCE_WALLET = vm.envAddress("CB_GOVERNANCE_WALLET");

    uint256 public constant COLLAB_GRANT_TOKENS = vm.envUint256("COLLAB_GRANT_TOKENS");
    uint256 public constant UPFRONT_GRANT_TOKENS = vm.envUint256("UPFRONT_GRANT_TOKENS");

    function _postCheck() internal override view {
        // TODO
    }

    function _buildCalls() internal override view returns (IMulticall3.Call3[] memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](3);

        // Transfer collaboration grant tokens to smart escrow
        calls[0] = IMulticall3.Call3({
            target: OP_TOKEN,
            allowFailure: false,
            callData: abi.encodeCall(
                token.safeTransferFrom(address, address, uint256);
                NESTED_SAFE,
                SMART_ESCROW,
                COLLAB_GRANT_TOKENS
            )
        });
        // Delegate governance tokens for initial grant to Agora's Alligator proxy, which will allow for subdelegations
        calls[1] = IMulticall3.Call3({
            target: OP_TOKEN,
            allowFailure: false,
            callData: abi.encodeCall(
                delegate(address),
                ALLIGATOR_PROXY
            )
        });

        SubdelegationRules subdelegationRules = SubdelegationRules({
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
                subdelegate(address, SubdelegationRules),
                CB_GOVERNANCE_WALLET,
                subdelegationRules
            )
        });

        return calls;
    }

    function _ownerSafe() internal override view returns (address) {
        return NESTED_SAFE;
    }
}