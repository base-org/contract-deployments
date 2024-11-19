// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "forge-std/Script.sol";
import "src/universal/ProxyAdmin.sol";
import "src/L1/SystemConfig.sol";

contract UpgradeL1StandardBridge is Script {
    address internal systemConfigProxy = vm.envAddress("SYSTEM_CONFIG_PROXY");
    address internal systemConfigImplementation = vm.envAddress("SYSTEM_CONFIG_IMPLEMENTATION");
    address internal proxyAdminOwner = vm.envAddress("PROXY_ADMIN_OWNER");

    // TODO: set values used in initialize below: 

    function run() public {
       vm.broadcast(proxyAdminOwner);
      
	ProxyAdmin proxyAdmin = ProxyAdmin(payable(vm.envAddress("PROXY_ADMIN")));
	proxyAdmin.upgradeAndCall({
	    _proxy: payable(systemConfigProxy),
            _implementation: systemConfigImplementation,
            _data: abi.encodeCall(
                systemConfig.initialize({
                    _owner: owner,
                    _basefeeScalar: basefeeScalar,
                    _blobbasefeeScalar: blobbasefeeScalar,
                    _batcherHash: batcherHash,
                    _gasLimit: gasLimit,
                    _unsafeBlockSigner: unsafeBlockSigner,
                    _config: IResourceMetering.ResourceConfig({
		        // TODO: Roberto confirm these:
                        maxResourceLimit: maxResourceLimit,
                        elasticityMultiplier: elasticityMultiplier,
                        baseFeeMaxChangeDenominator: baseFeeMaxChangeDenominator,
                        minimumBaseFee: minimumBaseFee,
                        systemTxMaxGas: systemTxMaxGas,
                        maximumBaseFee: maximumBaseFee
                    }),
                    _batchInbox: address(0),
                    _addresses: SystemConfig.Addresses({
                        l1CrossDomainMessenger: l1CrossDomainMessenger,
                        l1ERC721Bridge: l1ERC721Bridge,
                        l1StandardBridge: l1StandardBridge,
                        disputeGameFactory: disputeGameFactory,
                        optimismPortal: optimismPortal,
                        optimismMintableERC20Factory: optimismMintableERC20Factory,
                        gasPayingToken: gasPayingToken
                    })
                })
            )
	});
    }
}
