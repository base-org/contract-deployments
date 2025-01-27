// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@base-contracts/script/universal/MultisigBuilder.sol";

// Removes a signer from a multisig.
contract RemoveSigner is MultisigBuilder {
    uint256 private constant _THRESHOLD = 1;

    uint256 internal constant _EXPECTED_KEEPER_THRESHOLD = 3;
    uint256 internal constant _EXPECTED_KEEPER_OWNER_COUNT = 6;

    address internal _SIGNER_TO_KEEP = vm.envAddress("SIGNER_TO_KEEP");
    address internal _OWNER_SAFE = vm.envAddress("OWNER_SAFE");

    address prevOwner;
    address ownerToRemove;
    uint256 ownerCountBefore;

    function setUp() public {
        require(
            IGnosisSafe(_SIGNER_TO_KEEP).getThreshold() == _EXPECTED_KEEPER_THRESHOLD, "Precheck threshold mismatch"
        );
        require(
            IGnosisSafe(_SIGNER_TO_KEEP).getOwners().length == _EXPECTED_KEEPER_OWNER_COUNT, "Precheck length mismatch"
        );

        address[] memory currentOwners = IGnosisSafe(_OWNER_SAFE).getOwners();
        uint256 length = currentOwners.length;

        require(length > 1, "No signers to remove");

        prevOwner = currentOwners[length - 2];
        ownerToRemove = currentOwners[length - 1];
        ownerCountBefore = length;

        require(ownerToRemove != _SIGNER_TO_KEEP, "Owner to remove is the new signer");
    }

    function _postCheck(Vm.AccountAccess[] memory, Simulation.Payload memory) internal view override {
        require(
            IGnosisSafe(_SIGNER_TO_KEEP).getThreshold() == _EXPECTED_KEEPER_THRESHOLD, "Precheck threshold mismatch"
        );
        require(
            IGnosisSafe(_SIGNER_TO_KEEP).getOwners().length == _EXPECTED_KEEPER_OWNER_COUNT, "Precheck length mismatch"
        );

        require(IGnosisSafe(_OWNER_SAFE).getThreshold() == _THRESHOLD, "Postcheck threshold mismatch");
        require(IGnosisSafe(_OWNER_SAFE).getOwners().length == ownerCountBefore - 1, "Postcheck: Invalid owner count");

        require(!IGnosisSafe(_OWNER_SAFE).isOwner(ownerToRemove), "Postcheck: Owner not removed");
        require(IGnosisSafe(_OWNER_SAFE).isOwner(_SIGNER_TO_KEEP), "Postcheck: New signer was removed");
    }

    function _buildCalls() internal view override returns (IMulticall3.Call3[] memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](1);

        calls[0] = IMulticall3.Call3({
            target: _OWNER_SAFE,
            allowFailure: false,
            callData: abi.encodeCall(IGnosisSafe.removeOwner, (prevOwner, ownerToRemove, _THRESHOLD))
        });

        return calls;
    }

    function _ownerSafe() internal view override returns (address) {
        return _OWNER_SAFE;
    }
}
