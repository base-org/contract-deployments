// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@base-contracts/script/universal/NestedMultisigBuilder.sol";

// Sets threshold of nested multisig
contract SetThreshold is NestedMultisigBuilder {
    uint256 internal constant _THRESHOLD = 2;

    uint256 internal constant _EXPECTED_STARTING_OWNER_THRESHOLD = 1;
    uint256 internal constant _EXPECTED_OWNER_COUNT = 2;

    address internal _OWNER_SAFE = vm.envAddress("OWNER_SAFE");

    function setUp() public view {
        require(
            IGnosisSafe(_OWNER_SAFE).getThreshold() == _EXPECTED_STARTING_OWNER_THRESHOLD,
            "Precheck owner threshold mismatch"
        );
        require(IGnosisSafe(_OWNER_SAFE).getOwners().length == _EXPECTED_OWNER_COUNT, "Precheck length mismatch");
    }

    function _postCheck(Vm.AccountAccess[] memory, Simulation.Payload memory) internal view override {
        require(IGnosisSafe(_OWNER_SAFE).getThreshold() == _THRESHOLD, "Postcheck threshold mismatch");
        require(IGnosisSafe(_OWNER_SAFE).getOwners().length == _EXPECTED_OWNER_COUNT, "Postcheck length mismatch");
    }

    function _buildCalls() internal view override returns (IMulticall3.Call3[] memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](1);

        calls[0] = IMulticall3.Call3({
            target: _OWNER_SAFE,
            allowFailure: false,
            callData: abi.encodeCall(IGnosisSafe.changeThreshold, (_THRESHOLD))
        });

        return calls;
    }

    function _ownerSafe() internal view override returns (address) {
        return _OWNER_SAFE;
    }
}
