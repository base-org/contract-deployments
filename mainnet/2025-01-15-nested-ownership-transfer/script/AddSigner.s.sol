// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@base-contracts/script/universal/MultisigBuilder.sol";

// Adds `_SIGNER_TO_ADD` as an owner to `_OWNER_SAFE` and sets threshold to 1
contract AddSigner is MultisigBuilder {
    uint256 internal constant _THRESHOLD = 1;

    uint256 internal constant _EXPECTED_OWNER_COUNT = 6;
    uint256 internal constant _EXPECTED_OWNER_THRESHOLD = 3;

    uint256 internal constant _EXPECTED_NEW_SIGNER_OWNER_COUNT = 6;
    uint256 internal constant _EXPECTED_NEW_SIGNER_THRESHOLD = 3;

    address internal _SIGNER_TO_ADD = vm.envAddress("ADD_SIGNER_SIGNER_TO_ADD");
    address internal _OWNER_SAFE = vm.envAddress("OWNER_SAFE");

    /// @dev Confirm starting multisig heirarchy
    function setUp() public view {
        address[] memory currentOwners = IGnosisSafe(_OWNER_SAFE).getOwners();
        address[] memory newSignerOwners = IGnosisSafe(_SIGNER_TO_ADD).getOwners();

        require(currentOwners.length == _EXPECTED_OWNER_COUNT, "Precheck owner count mismatch");
        require(newSignerOwners.length == _EXPECTED_NEW_SIGNER_OWNER_COUNT, "Precheck length mismatch");

        require(
            IGnosisSafe(_OWNER_SAFE).getThreshold() == _EXPECTED_OWNER_THRESHOLD, "Precheck owner threshold mismatch"
        );
        require(
            IGnosisSafe(_SIGNER_TO_ADD).getThreshold() == _EXPECTED_NEW_SIGNER_THRESHOLD,
            "Precheck new signer threshold mismatch"
        );

        for (uint256 i; i < currentOwners.length; i++) {
            require(currentOwners[i] == newSignerOwners[i], "Precheck owner mismatch");
        }
    }

    /// @dev Confirm ending multisig heirarchy
    function _postCheck(Vm.AccountAccess[] memory, Simulation.Payload memory) internal view override {
        address[] memory currentOwners = IGnosisSafe(_OWNER_SAFE).getOwners();
        address[] memory newSignerOwners = IGnosisSafe(_SIGNER_TO_ADD).getOwners();

        require(currentOwners.length == _EXPECTED_OWNER_COUNT + 1, "Postcheck owner count mismatch");
        require(newSignerOwners.length == _EXPECTED_NEW_SIGNER_OWNER_COUNT, "Postcheck length mismatch");

        require(IGnosisSafe(_OWNER_SAFE).getThreshold() == _THRESHOLD, "Postcheck owner threshold mismatch");
        require(
            IGnosisSafe(_SIGNER_TO_ADD).getThreshold() == _EXPECTED_NEW_SIGNER_THRESHOLD,
            "Postcheck new signer threshold mismatch"
        );

        for (uint256 i; i < newSignerOwners.length; i++) {
            require(currentOwners[i + 1] == newSignerOwners[i], "Postcheck owner mismatch");
        }

        require(currentOwners[0] == _SIGNER_TO_ADD, "Postcheck new signer mismatch");
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
