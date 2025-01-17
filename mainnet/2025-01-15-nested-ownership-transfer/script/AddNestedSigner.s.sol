// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@base-contracts/script/universal/NestedMultisigBuilder.sol";

// Adds new multisig signer to existing multisig and updates threshold to 1
// New signer should be a 7-of-10 multisig
contract AddNestedSigner is NestedMultisigBuilder {
    uint256 internal constant _THRESHOLD = 1;
    uint256 internal constant _EXPECTED_STARTING_OWNER_COUNT = 1;

    uint256 internal constant _EXPECTED_CHILD_SIGNER_THRESHOLD = 7;
    uint256 internal constant _EXPECTED_CHILD_SIGNER_OWNER_COUNT = 10;

    address internal _CHILD_SIGNER = vm.envAddress("CHILD_SIGNER");
    address internal _SIGNER_CURRENT = vm.envAddress("SIGNER_CURRENT");

    /// @dev Confirm starting multisig heirarchy
    function setUp() public view {
        address[] memory currentOwners = IGnosisSafe(_SIGNER_CURRENT).getOwners();
        address[] memory childOwners = IGnosisSafe(_CHILD_SIGNER).getOwners();

        require(currentOwners.length == _EXPECTED_STARTING_OWNER_COUNT, "Precheck length mismatch");
        require(childOwners.length == _EXPECTED_CHILD_SIGNER_OWNER_COUNT, "Precheck child signer owner count mismatch");
        require(
            IGnosisSafe(_CHILD_SIGNER).getThreshold() == _EXPECTED_CHILD_SIGNER_THRESHOLD,
            "Precheck child signer threshold mismatch"
        );
    }

    /// @dev Confirm ending multisig heirarchy
    function _postCheck(Vm.AccountAccess[] memory, Simulation.Payload memory) internal view override {
        address[] memory currentOwners = IGnosisSafe(_SIGNER_CURRENT).getOwners();

        require(currentOwners[0] == _CHILD_SIGNER, "Postcheck new signer mismatch");
        require(IGnosisSafe(_SIGNER_CURRENT).getThreshold() == _THRESHOLD, "Postcheck threshold mismatch");
        require(currentOwners.length == _EXPECTED_STARTING_OWNER_COUNT + 1, "Postcheck length mismatch");
    }

    function _buildCalls() internal view override returns (IMulticall3.Call3[] memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](1);

        calls[0] = IMulticall3.Call3({
            target: _SIGNER_CURRENT,
            allowFailure: false,
            callData: abi.encodeCall(IGnosisSafe.addOwnerWithThreshold, (_CHILD_SIGNER, _THRESHOLD))
        });

        return calls;
    }

    function _ownerSafe() internal view override returns (address) {
        return _SIGNER_CURRENT;
    }
}
