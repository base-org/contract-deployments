// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@base-contracts/script/universal/MultisigBuilder.sol";

// STEP 1

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
    function _postCheck(Vm.AccountAccess[] memory accesses, Simulation.Payload memory) internal view override {
        address[] memory currentOwners = IGnosisSafe(_SIGNER_CURRENT).getOwners();
        address[] memory newSignerOwners = IGnosisSafe(_SIGNER_NEW).getOwners();

        require(currentOwners.length == newSignerOwners.length + 1, "Postcheck length mismatch");

        for (uint256 i; i < newSignerOwners.length; i++) {
            require(currentOwners[i] == newSignerOwners[i], "Postcheck owner mismatch");
        }

        require(currentOwners[currentOwners.length - 1] == _SIGNER_NEW, "Postcheck new signer mismatch");
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
            callData: abi.encodeCall(IGnosisSafe.addOwnerWithThreshold, (_SIGNER_NEW, _THRESHOLD))
        });

        return calls;
    }

    function _ownerSafe() internal view override returns (address) {
        return _SIGNER_CURRENT;
    }
}
