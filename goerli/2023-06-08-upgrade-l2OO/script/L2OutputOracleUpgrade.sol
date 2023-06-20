// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Script.sol";
import "forge-std/StdJson.sol";
import "script/deploy/Utils.sol";
import { L2OutputOracle } from "@eth-optimism-bedrock/contracts/L1/L2OutputOracle.sol";
import { Proxy } from "@eth-optimism-bedrock/contracts/universal/Proxy.sol";
import { LibSort } from "@eth-optimism-bedrock/scripts/libraries/LibSort.sol";
import { ProxyAdmin } from "@eth-optimism-bedrock/contracts/universal/ProxyAdmin.sol";
import { IGnosisSafe, Enum } from "@eth-optimism-bedrock/scripts/interfaces/IGnosisSafe.sol";

contract L2OutputOracleUpgrade is Script {
    using stdJson for string;
    Utils addressUtils;
    address[] internal approvals;

    struct L2OutputOracleUpgradeConfig {
        address newImplementationAddr;
        address proxyAddr;
        address proxyAdmin;
        address proxyAdminOwner;
    }
    L2OutputOracleUpgradeConfig cfg;

    function run(address signerAddr) public {
        string memory root = vm.projectRoot();
        string memory path = string.concat(root, "inputs/config.json");
        string memory json = vm.readFile(path);
        bytes memory upgradeConfigRaw = json.parseRaw(".L2OutputOracleUpgrade");
        cfg = abi.decode(upgradeConfigRaw, (L2OutputOracleUpgradeConfig));

        console.log("Upgrading L2 output oracle");
        console.logAddress(cfg.newImplementationAddr);
        console.logAddress(cfg.proxyAddr);
        console.logAddress(cfg.proxyAdmin);
        console.logAddress(cfg.proxyAdminOwner);

        IGnosisSafe proxyAdminOwner = IGnosisSafe(payable(cfg.proxyAdminOwner));
        bytes memory upgradeData = abi.encodeWithSignature("upgrade(address,address)", cfg.proxyAddr, cfg.newImplementationAddr);
        uint256 nonce = proxyAdminOwner.nonce();

        vm.startBroadcast(signerAddr); // Key which is in the gnosis safe multisig
        bytes32 txHash = proxyAdminOwner.getTransactionHash(
            {
            to: cfg.proxyAdmin,
            value: 0,
            data: upgradeData,
            operation: Enum.Operation.Call,
            safeTxGas: 0,
            baseGas: 0,
            gasPrice: 0,
            gasToken: address(0),
            refundReceiver: address(0),
            _nonce: nonce
        });
        proxyAdminOwner.approveHash(txHash);       

        bool executed = executeIfThresholdMet(proxyAdminOwner, txHash, cfg.proxyAdmin, upgradeData);
        console.log(executed);
        vm.stopBroadcast();
    }

    function executeIfThresholdMet(IGnosisSafe safe, bytes32 approveHash, address toContract, bytes memory data) internal returns (bool) {
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

 
