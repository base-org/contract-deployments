// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@base-contracts/script/universal/MultisigBuilder.sol";

// Removes a signer from a multisig.
contract RemoveSigner is MultisigBuilder {
    uint256 private constant _THRESHOLD = 1;
    address internal constant SENTINEL_OWNERS = address(0x1);

    address internal _SIGNER_NEW = vm.envAddress("SIGNER_NEW");
    address internal _SIGNER_CURRENT = vm.envAddress("SIGNER_CURRENT");

    address prevOwner;
    address ownerToRemove;
    uint256 ownerCountBefore;

    function setUp() public {
        address[] memory currentOwners = IGnosisSafe(_SIGNER_CURRENT).getOwners();
        uint256 length = currentOwners.length;

        require(length > 1, "No signers to remove");

        prevOwner = currentOwners[length - 2];
        ownerToRemove = currentOwners[length - 1];
        ownerCountBefore = length;

        require(ownerToRemove != _SIGNER_NEW, "Owner to remove is the new signer");
    }

    function _postCheck(Vm.AccountAccess[] memory, Simulation.Payload memory) internal view override {
        address[] memory currentOwners = IGnosisSafe(_SIGNER_CURRENT).getOwners();

        require(currentOwners.length == ownerCountBefore - 1, "Postcheck: Invalid owner count");
        require(!IGnosisSafe(_SIGNER_CURRENT).isOwner(ownerToRemove), "Postcheck: Owner not removed");
        require(IGnosisSafe(_SIGNER_CURRENT).getThreshold() == _THRESHOLD, "Postcheck threshold mismatch");
    }

    function _buildCalls() internal view override returns (IMulticall3.Call3[] memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](1);

        calls[0] = IMulticall3.Call3({
            target: _SIGNER_CURRENT,
            allowFailure: false,
            callData: abi.encodeCall(IGnosisSafe.removeOwner, (prevOwner, ownerToRemove, _THRESHOLD))
        });

        return calls;
    }

    function _ownerSafe() internal view override returns (address) {
        return _SIGNER_CURRENT;
    }
}
