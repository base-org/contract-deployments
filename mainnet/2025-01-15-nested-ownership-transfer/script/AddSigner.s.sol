// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@base-contracts/script/universal/MultisigBuilder.sol";

// Adds new signer to existing multisig and reduces threshold to 1
// New signer should be a 3-of-6 multisig with same signers as the current multisig
contract AddSigner is MultisigBuilder {
    uint256 internal constant _THRESHOLD = 1;
    uint256 internal constant _EXPECTED_OWNER_COUNT = 6;
    uint256 internal constant _EXPECTED_STARTING_THRESHOLD = 3;

    address internal _SIGNER_NEW = vm.envAddress("SIGNER_NEW");
    address internal _SIGNER_CURRENT = vm.envAddress("SIGNER_CURRENT");

    /// @dev Confirm starting multisig heirarchy
    function setUp() public view {
        address[] memory currentOwners = IGnosisSafe(_SIGNER_CURRENT).getOwners();
        address[] memory newSignerOwners = IGnosisSafe(_SIGNER_NEW).getOwners();

        require(currentOwners.length == newSignerOwners.length, "Precheck length mismatch");
        require(currentOwners.length == _EXPECTED_OWNER_COUNT, "Precheck owner count mismatch");
        require(IGnosisSafe(_SIGNER_NEW).getThreshold() == _EXPECTED_STARTING_THRESHOLD, "Precheck threshold mismatch");

        for (uint256 i; i < currentOwners.length; i++) {
            require(currentOwners[i] == newSignerOwners[i], "Precheck owner mismatch");
        }
    }

    /// @dev Confirm ending multisig heirarchy
    function _postCheck(Vm.AccountAccess[] memory, Simulation.Payload memory) internal view override {
        address[] memory currentOwners = IGnosisSafe(_SIGNER_CURRENT).getOwners();
        address[] memory newSignerOwners = IGnosisSafe(_SIGNER_NEW).getOwners();

        require(currentOwners.length == newSignerOwners.length + 1, "Postcheck length mismatch");

        for (uint256 i; i < newSignerOwners.length; i++) {
            require(currentOwners[i + 1] == newSignerOwners[i], "Postcheck owner mismatch");
        }

        require(currentOwners[0] == _SIGNER_NEW, "Postcheck new signer mismatch");
        require(IGnosisSafe(_SIGNER_CURRENT).getThreshold() == _THRESHOLD, "Postcheck threshold mismatch");
    }

    function _buildCalls() internal view override returns (IMulticall3.Call3[] memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](1);

        calls[0] = IMulticall3.Call3({
            target: _SIGNER_CURRENT,
            allowFailure: false,
            callData: abi.encodeCall(IGnosisSafe.addOwnerWithThreshold, (_SIGNER_NEW, _THRESHOLD))
        });

        return calls;
    }

    function _ownerSafe() internal view override returns (address) {
        return _SIGNER_CURRENT;
    }
}
