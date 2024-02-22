// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@base-contracts/script/universal/NestedMultisigBuilder.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

// TODO: this script will be called after the upfront grant tokens have vested
contract TransferOPTokens is NestedMultisigBuilder {
    using SafeERC20 for IERC20;

    address constant internal NESTED_SAFE = vm.envAddress("NESTED_SAFE");
    IERC20 public constant OP_TOKEN = IERC20(vm.envAddress("OP_TOKEN"));
    address public constant BENEFICIARY = vm.envAddress("BENEFICIARY");
    uint256 public constant UPFRONT_GRANT_TOKENS = vm.envUint256("UPFRONT_GRANT_TOKENS");

    function _postCheck() internal override view {
        // TODO
    }

    function _buildCalls() internal override view returns (IMulticall3.Call3[] memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](1);

        // Transfer upfront grant tokens when they vest
        calls[0] = IMulticall3.Call3({
            target: OP_TOKEN,
            allowFailure: false,
            callData: abi.encodeCall(
                token.safeTransferFrom(address, address, uint256);
                NESTED_SAFE,
                BENEFICIARY,
                UPFRONT_GRANT_TOKENS // or maybe just the whole balance?
            )
        });

        return calls;
    }

    function _ownerSafe() internal override view returns (address) {
        return NESTED_SAFE;
    }
}