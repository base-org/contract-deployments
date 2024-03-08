// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {SystemConfig} from "@eth-optimism-bedrock/src/L1/SystemConfig.sol";
import {
    MultisigBuilder, 
    IMulticall3, 
    IGnosisSafe,
    console,
    Enum
} from "@base-contracts/script/universal/MultisigBuilder.sol";

contract UpdateGasConfig is MultisigBuilder {

    address internal SYSTEM_CONFIG_OWNER = vm.envAddress("SYSTEM_CONFIG_OWNER");
    address internal L1_SYSTEM_CONFIG = vm.envAddress("L1_SYSTEM_CONFIG_ADDRESS");
    uint256 internal SCALAR = vm.envUint("SCALAR");

    function _postCheck() internal override view {
        require(SystemConfig(L1_SYSTEM_CONFIG).scalar() == SCALAR);
        require(SystemConfig(L1_SYSTEM_CONFIG).overhead() == 0);
    }

    function _buildCalls() internal override view returns (IMulticall3.Call3[] memory) {
        IMulticall3.Call3[] memory calls = new IMulticall3.Call3[](1);

        calls[0] = IMulticall3.Call3({
            target: L1_SYSTEM_CONFIG,
            allowFailure: false,
            callData: abi.encodeCall(
                SystemConfig.setGasConfig,
                (
                0, // overhead is not used post Ecotone
                SCALAR
                )
            )
        });

        return calls;
    }

    function _ownerSafe() internal override view returns (address) {
        return SYSTEM_CONFIG_OWNER;
    }

    function _simulateForSigner(address _safe, IMulticall3.Call3[] memory _calls) internal override view {
        IGnosisSafe safe = IGnosisSafe(payable(_safe));
        bytes memory data = abi.encodeCall(IMulticall3.aggregate3, (_calls));

        uint256 _nonce = safe.nonce();
        console.log("Safe current nonce:", _nonce);

        // workaround to check if the SAFE_NONCE env var is present
        try vm.envUint("SAFE_NONCE") {
            _nonce = vm.envUint("SAFE_NONCE");
            console.log("Creating transaction with nonce:", _nonce);
        }
        catch {}

        SimulationStateOverride[] memory overrides = new SimulationStateOverride[](1);
        // The state change simulation sets the multisig threshold to 1 and the owner
        // to the foundry default sender address so that the simulation can be run by 
        // someone without one of the owning keys.
        // The multisig threshold and owner will not actually change in the prod 
        // transaction execution.
        overrides[0] = overrideSafeThresholdAndOwner(_safe, DEFAULT_SENDER);

        logSimulationLink({
            _to: _safe,
            _data: abi.encodeCall(
                safe.execTransaction,
                (
                    address(multicall),
                    0,
                    data,
                    Enum.Operation.DelegateCall,
                    0,
                    0,
                    0,
                    address(0),
                    payable(address(0)),
                    prevalidatedSignature(msg.sender)
                )
            ),
            _from: msg.sender,
            _overrides: overrides
        });
    }
}