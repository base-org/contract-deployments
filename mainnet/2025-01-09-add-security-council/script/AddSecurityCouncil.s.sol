// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@base-contracts/script/universal/NestedMultisigBuilder.sol";

// Start: 
// Gov (CB_old, OP)
// CB_new (Base_SC, CB_old)

// End:
// Gov (CB_new, OP)
// CB_new (Base_SC, CB_old)
contract AddSecurityCouncil is NestedMultisigBuilder {
    address internal _BASE_SECURITY_COUNCIL = vm.envAddress("BASE_SECURITY_COUNCIL");
    address internal _COINBASE_SIGNER_NEW = vm.envAddress("COINBASE_SIGNER_NEW");
    address internal _COINBASE_SIGNER_CURRENT = vm.envAddress("COINBASE_SIGNER_CURRENT");
    address internal _GOVERNANCE_MULTISIG = vm.envAddress("GOVERNANCE_MULTISIG");
    address internal _OP_MULTISIG = vm.envAddress("OP_MULTISIG");

    /// @dev Confirm starting multisig heirarchy
    function setUp() public {
        require(IGnosisSafe(_GOVERNANCE_MULTISIG).getOwners().length == 2, "Governance multisig should have 2 owners");
        require(IGnosisSafe(_GOVERNANCE_MULTISIG).isOwner(_COINBASE_SIGNER_CURRENT), "Coinbase signer is not owner of governance multisig");
        require(IGnosisSafe(_GOVERNANCE_MULTISIG).isOwner(_OP_MULTISIG), "OP multisig is not owner of governance multisig");

        require(IGnosisSafe(_COINBASE_SIGNER_NEW).getOwners().length == 2, "New CB Signer multisig should have 2 owners");
        require(IGnosisSafe(_COINBASE_SIGNER_NEW).isOwner(_BASE_SECURITY_COUNCIL), "Base Security Council is not owner of new CB Signer multisig");
        require(IGnosisSafe(_COINBASE_SIGNER_NEW).isOwner(_COINBASE_SIGNER_CURRENT), "Current CB Signer is not owner of new CB Signer multisig");
    }

    /// @dev Confirm ending multisig heirarchy
    function _postCheck(Vm.AccountAccess[] memory, Simulation.Payload memory) internal view override {
        require(IGnosisSafe(_GOVERNANCE_MULTISIG).getOwners().length == 2, "Governance multisig should have 2 owners");
        require(IGnosisSafe(_GOVERNANCE_MULTISIG).isOwner(_OP_MULTISIG), "OP multisig is not owner of governance multisig");
        require(IGnosisSafe(_GOVERNANCE_MULTISIG).isOwner(_COINBASE_SIGNER_NEW), "New CB Signer multisig is not owner of governance multisig");

        require(IGnosisSafe(_COINBASE_SIGNER_NEW).getOwners().length == 2, "New CB Signer multisig should have 2 owners");
        require(IGnosisSafe(_COINBASE_SIGNER_NEW).isOwner(_BASE_SECURITY_COUNCIL), "Base Security Council is not owner of new CB Signer multisig");
        require(IGnosisSafe(_COINBASE_SIGNER_NEW).isOwner(_COINBASE_SIGNER_CURRENT), "Current CB Signer is not owner of new CB Signer multisig");
    }

    function _buildCalls() internal view override returns (IMulticall3.Call3[] memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](1);

        calls[0] = IMulticall3.Call3({
            target: _GOVERNANCE_MULTISIG,
            allowFailure: false,
            callData: abi.encodeCall(IGnosisSafe.swapOwner, (_OP_MULTISIG, _COINBASE_SIGNER_CURRENT, _COINBASE_SIGNER_NEW))
        });

        return calls;
    }

    function _ownerSafe() internal view override returns (address) {
        return _GOVERNANCE_MULTISIG;
    }
}
