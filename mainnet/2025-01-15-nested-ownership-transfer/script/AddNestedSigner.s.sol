// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@base-contracts/script/universal/NestedMultisigBuilder.sol";

// Adds new multisig signer to existing multisig and updates threshold to 1
// New signer should be a 7-of-10 multisig
contract AddNestedSigner is NestedMultisigBuilder {
    uint256 internal constant _THRESHOLD = 1;

    uint256 internal constant _EXPECTED_STARTING_OWNER_COUNT = 1;
    uint256 internal constant _EXPECTED_STARTING_OWNER_THRESHOLD = 1;

    uint256 internal constant _EXPECTED_CHILD_SIGNER_THRESHOLD = 7;
    uint256 internal constant _EXPECTED_CHILD_SIGNER_OWNER_COUNT = 10;

    address internal _SIGNER_TO_ADD = vm.envAddress("CHILD_SIGNER");
    address internal _OWNER_SAFE = vm.envAddress("SIGNER_CURRENT");

    /// @dev Confirm starting multisig heirarchy
    function setUp() public view {
        address[] memory currentOwners = IGnosisSafe(_OWNER_SAFE).getOwners();
        address[] memory childOwners = IGnosisSafe(_SIGNER_TO_ADD).getOwners();

        require(currentOwners.length == _EXPECTED_STARTING_OWNER_COUNT, "Precheck length mismatch");
        require(childOwners.length == _EXPECTED_CHILD_SIGNER_OWNER_COUNT, "Precheck child signer owner count mismatch");

        require(
            IGnosisSafe(_SIGNER_TO_ADD).getThreshold() == _EXPECTED_CHILD_SIGNER_THRESHOLD,
            "Precheck child signer threshold mismatch"
        );
        require(
            IGnosisSafe(_OWNER_SAFE).getThreshold() == _EXPECTED_STARTING_OWNER_THRESHOLD,
            "Precheck owner threshold mismatch"
        );
    }

    /// @dev Confirm ending multisig heirarchy
    function _postCheck(Vm.AccountAccess[] memory, Simulation.Payload memory) internal view override {
        address[] memory currentOwners = IGnosisSafe(_OWNER_SAFE).getOwners();
        address[] memory childOwners = IGnosisSafe(_SIGNER_TO_ADD).getOwners();

        require(currentOwners[0] == _SIGNER_TO_ADD, "Postcheck new signer mismatch");

        require(currentOwners.length == _EXPECTED_STARTING_OWNER_COUNT + 1, "Postcheck length mismatch");
        require(childOwners.length == _EXPECTED_CHILD_SIGNER_OWNER_COUNT, "Postcheck child signer owner count mismatch");

        require(IGnosisSafe(_OWNER_SAFE).getThreshold() == _THRESHOLD, "Postcheck threshold mismatch");
        require(
            IGnosisSafe(_SIGNER_TO_ADD).getThreshold() == _EXPECTED_CHILD_SIGNER_THRESHOLD,
            "Postcheck child signer threshold mismatch"
        );
    }

    function _buildCalls() internal view override returns (IMulticall3.Call3[] memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](1);

        calls[0] = IMulticall3.Call3({
            target: _OWNER_SAFE,
            allowFailure: false,
            callData: abi.encodeCall(IGnosisSafe.addOwnerWithThreshold, (_SIGNER_TO_ADD, _THRESHOLD))
        });

        return calls;
    }

    function _ownerSafe() internal view override returns (address) {
        return _OWNER_SAFE;
    }
}
