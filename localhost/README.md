# Local Testing

To setup a local environment, have two terminals open, both should cd to this `localhost` directory.

In one terminal, run `make node` and after that's done, run `make deploy` in the second terminal.

Once this setup is done, you can cd into your specific task directory in the second terminal and do any additional testing there (keep the node running in the first terminal).

### Details

`make node` runs a node using the Foundry tool `anvil`. It additionally takes in a genesis file which adds the Gnosis Safe contracts and `Multicall3` as predeploys. If you want any additional contracts to be deployed by default locally, they can be added to `setup/genesis.json`.

`make deploy` does a few things:
1. Deploy the L1 Base contracts to your local environment
2. Setup a Safe, which is a 2 of 3 multisig containing the first three default localhost accounts provided by Foundry as signers: `0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266`, `0x70997970C51812dc3A010C7d01b50e0d17dc79C8`, and `0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC`.
The address of the Safe is `0x41715dd88d95c3c80248f19dace21015346069b8`.
3. Transfer ownership of L1 contracts to this Safe.
4. Transfer ownership of SystemConfigOwner to this Safe. 

You may run these steps individually if you'd like to not do all of them.
