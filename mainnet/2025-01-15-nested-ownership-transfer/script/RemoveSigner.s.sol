// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@base-contracts/script/universal/MultisigBuilder.sol";

// STEP 2

// Removes a signer from a multisig. Should be called until only 1 signer is left.
contract RemoveSigner is MultisigBuilder {
    uint256 private constant _THRESHOLD = 1;
    address internal constant SENTINEL_OWNERS = address(0x1);

    address internal _SIGNER_NEW = vm.envAddress("SIGNER_NEW");
    address internal _SIGNER_CURRENT = vm.envAddress("SIGNER_CURRENT");

    address ownerToRemove;
    uint256 ownerCountBefore;

    function setUp() public {
        address[] memory currentOwners = IGnosisSafe(_SIGNER_CURRENT).getOwners();

        require(currentOwners.length > 1, "No signers to remove");
        require(ownerToRemove != _SIGNER_NEW, "Owner to remove is the new signer");

        ownerToRemove = currentOwners[0];
        ownerCountBefore = currentOwners.length;
    }

    function _postCheck(Vm.AccountAccess[] memory accesses, Simulation.Payload memory) internal view override {
        address[] memory currentOwners = IGnosisSafe(_SIGNER_CURRENT).getOwners();

        require(currentOwners.length == ownerCountBefore - 1, "Postcheck: Invalid owner count");
        require(!IGnosisSafe(_SIGNER_CURRENT).isOwner(ownerToRemove), "Postcheck: Owner not removed");
        require(IGnosisSafe(_SIGNER_CURRENT).getThreshold() == _THRESHOLD, "Postcheck threshold mismatch");

        for (uint256 i; i < accesses.length; i++) {
            console.log("Accesses");
            console.log("chainInfo.forkId: ", accesses[i].chainInfo.forkId);
            console.log("chainInfo.chainId: ", accesses[i].chainInfo.chainId);
            console.log("kind: ", uint256(accesses[i].kind));
            console.log("account: ", accesses[i].account);
            console.log("accessor: ", accesses[i].accessor);
            console.log("initialized: ", accesses[i].initialized);
            console.log("oldBalance: ", accesses[i].oldBalance);
            console.log("newBalance: ", accesses[i].newBalance);
            console.log("deployedCode: ");
            console.logBytes(accesses[i].deployedCode);
            console.log("value: ", accesses[i].value);
            console.log("data: ");
            console.logBytes(accesses[i].data);
            console.log("reverted: ", accesses[i].reverted);
            console.log("depth: ", accesses[i].depth);

            for (uint256 j; j < accesses[i].storageAccesses.length; j++) {
                console.log("storageAccesses", j);
                console.log("account: ", accesses[i].storageAccesses[j].account);
                console.log("slot: ");
                console.logBytes32(accesses[i].storageAccesses[j].slot);
                console.log("isWrite: ", accesses[i].storageAccesses[j].isWrite);
                console.log("previousValue: ");
                console.logBytes32(accesses[i].storageAccesses[j].previousValue);
                console.log("newValue: ");
                console.logBytes32(accesses[i].storageAccesses[j].newValue);
                console.log("reverted: ", accesses[i].storageAccesses[j].reverted);
            }
        }
    }

    function _buildCalls() internal view override returns (IMulticall3.Call3[] memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](1);

        calls[0] = IMulticall3.Call3({
            target: _SIGNER_CURRENT,
            allowFailure: false,
            callData: abi.encodeCall(IGnosisSafe.removeOwner, (SENTINEL_OWNERS, ownerToRemove, _THRESHOLD))
        });

        return calls;
    }

    function _ownerSafe() internal view override returns (address) {
        return _SIGNER_CURRENT;
    }
}
