// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/StdJson.sol";
import { LibSort } from "@eth-optimism-bedrock/scripts/libraries/LibSort.sol";
import {
    OwnableUpgradeable
} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import { IGnosisSafe, Enum } from "@eth-optimism-bedrock/scripts/interfaces/IGnosisSafe.sol";

contract TransferOwnershipForcedInclusion is Script {
    address[] internal approvals;

    function run(address proxyAdmin, address oldOwner, address newOwner, address signer) public {
        IGnosisSafe existingOwner = IGnosisSafe(payable(oldOwner));
        bytes memory transferOwnerData = abi.encodeWithSignature("transferOwnership(address)", newOwner);
        uint256 nonce = existingOwner.nonce();

        vm.startBroadcast(signer);
        bytes32 txHash = existingOwner.getTransactionHash({
            to: proxyAdmin,
            value: 0,
            data: transferOwnerData,
            operation: Enum.Operation.Call,
            safeTxGas: 0,
            baseGas: 0,
            gasPrice: 0,
            gasToken: address(0),
            refundReceiver: address(0),
            _nonce: nonce
        });
        existingOwner.approveHash(txHash);       

        bool executed = executeIfThresholdMet(existingOwner, txHash, proxyAdmin, transferOwnerData);
        console.log(executed);
        vm.stopBroadcast();
    }

    function executeIfThresholdMet(
        IGnosisSafe safe, bytes32 approveHash, address toContract, bytes memory data
    ) internal returns (bool) {
        uint256 threshold = safe.getThreshold();
        address[] memory owners = safe.getOwners();

        for (uint256 i; i < owners.length; i++) {
            address owner = owners[i];
            uint256 approved = safe.approvedHashes(owner, approveHash);
            if (approved == 1) {
                approvals.push(owner);
            }
        }

        if (approvals.length >= threshold) {
            bytes memory signatures = buildSignatures();

            bool success = safe.execTransaction({
                to: toContract,
                value: 0,
                data: data,
                operation: Enum.Operation.Call,
                safeTxGas: 0,
                baseGas: 0,
                gasPrice: 0,
                gasToken: address(0),
                refundReceiver: payable(address(0)),
                signatures: signatures
            });
            require(success, "call not successful");
            return true;
        } else {
            console.log("not enough approvals");
            console.log(approvals.length);
            console.log(threshold);
        }
        return false;
    }

    /**
     * @notice Builds the signatures by tightly packing them together.
     *         Ensures that they are sorted.
     */
    function buildSignatures() internal view returns (bytes memory) {
        address[] memory addrs = new address[](approvals.length);
        for (uint256 i; i < approvals.length; i++) {
            addrs[i] = approvals[i];
        }

        LibSort.sort(addrs);

        bytes memory signatures;
        uint8 v = 1;
        bytes32 s = bytes32(0);
        for (uint256 i; i < addrs.length; i++) {
            bytes32 r = bytes32(uint256(uint160(addrs[i])));
            signatures = bytes.concat(signatures, abi.encodePacked(r, s, v));
        }
        return signatures;
    }

}
