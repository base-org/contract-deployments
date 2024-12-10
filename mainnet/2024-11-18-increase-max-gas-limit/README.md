# [READY TO SIGN] Upgrade to new system config with 400m max gas limit

## Objective

Base is continuing to scale and we need higher block gas limit to support the increased demand. In this upgrade, we will change the SystemConfig implementation to a patched version
that sets the max gas limit to 400m.

## Approving the transaction

### 1. Update repo and move to the appropriate folder:

```
cd contract-deployments
git pull
cd mainnet/2024-11-18-increase-max-gas-limit
make deps
```

### 2. Setup Ledger

Your Ledger needs to be connected and unlocked. The Ethereum
application needs to be opened on Ledger with the message "Application
is ready".

### 3. Simulate and validate the transaction

Make sure your ledger is still unlocked and run the following.

``` shell
make sign-op # or make sign-cb for Coinbase signers
```

Once you run the make sign command successfully, you will see a "Simulation link" from the output.

Paste this URL in your browser. A prompt may ask you to choose a
project, any project will do. You can create one if necessary.

Click "Simulate Transaction".

We will be performing 3 validations and then we'll extract the domain hash and
message hash to approve on your Ledger then verify completion:

1. Validate integrity of the simulation.
2. Validate correctness of the state diff.
3. Validate and extract domain hash and message hash to approve.
4. Validate that the transaction completed successfully

#### 3.1. Validate integrity of the simulation.

Make sure you are on the "Overview" tab of the tenderly simulation, to
validate integrity of the simulation, we need to check the following:

1. "Network": Check the network is Ethereum Mainnet.
2. "Timestamp": Check the simulation is performed on a block with a
   recent timestamp (i.e. close to when you run the script).
3. "Sender": Check the address shown is your signer account. If not,
   you will need to determine which “number” it is in the list of
   addresses on your ledger.
4. "Success" with a green check mark 

#### 3.2. Validate correctness of the state diff.

Now click on the "State" tab. Verify that:

1. Verify that the nonce is incremented for the Nested Multisig under the "GnosisSafeProxy" at address `0x7bB41C3008B3f03FE483B28b8DB90e19Cf07595c`: Double confirm with [Base Contracts](https://docs.base.org/docs/base-contracts/#base-mainnet-1) `Proxy Admin Owner (L1)`

```
Key: 0x0000000000000000000000000000000000000000000000000000000000000005
Before: 0x0000000000000000000000000000000000000000000000000000000000000003
After: 0x0000000000000000000000000000000000000000000000000000000000000004
```

2. And for the same contract, verify that this specific execution is approved by the other signer multisig:

```
Key (if you are an OP signer): 0x3de911d6c3893f34ba66d689f486b69c507df2b5b9000fca28603b49dfbc2c07
Key (if you are a CB signer): 0xc283012356139d32a690c5c85f0f9005bd90fce119f7c48cd92e2a585cc1ab41
Before: 0x0000000000000000000000000000000000000000000000000000000000000000
After: 0x0000000000000000000000000000000000000000000000000000000000000001
```

3. Verify that the nonce is incremented for your multisig.

If you are an OP signer - the OP Foundation Multisig should be under the "GnosisSafeProxy" at address `0x9BA6e03D8B90dE867373Db8cF1A58d2F7F006b3A`: Double confirm with [Base Contracts](https://docs.base.org/docs/base-contracts/#base-mainnet-1) `L1 Nested Safe Signer (Optimism)`

```
Key: 0x0000000000000000000000000000000000000000000000000000000000000005
Before: 0x0000000000000000000000000000000000000000000000000000000000000060
After: 0x0000000000000000000000000000000000000000000000000000000000000061
```

If you are a CB signer - the Coinbase Multisig should be under the address `0x9855054731540A48b28990B63DcF4f33d8AE46A1`: Double confirm with [Base Contracts](https://docs.base.org/docs/base-contracts/#base-mainnet-1) `L1 Nested Safe Signer (Coinbase)`

```
Key: 0x0000000000000000000000000000000000000000000000000000000000000005
Before: 0x000000000000000000000000000000000000000000000000000000000000000f
After: 0x0000000000000000000000000000000000000000000000000000000000000010
```

1. Verify that the state changes for Base SystemConfigProxy `0x73a79Fab69143498Ed3712e519A88a918e1f4072` are correctly pointing to the new implementation: Double confirm with [Base Contracts](https://docs.base.org/docs/base-contracts/#ethereum-mainnet) `System Config`

```
Key: 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
Before: 0x000000000000000000000000f56d96b2535b932656d3c04ebf51babff241d886
After: 0x0000000000000000000000003c768a33c473f664678b58c2253db096b41f7cfc
```

Current implementation: [0xf56d96b2535b932656d3c04ebf51babff241d886](https://etherscan.io/address/0xf56d96b2535b932656d3c04ebf51babff241d886#code)
New implementation: [0x3c768a33c473f664678b58c2253db096b41f7cfc](https://etherscan.io/address/0x3c768a33c473f664678b58c2253db096b41f7cfc#code)


#### 3.3. Extract the domain hash and the message hash to approve.

Now that we have verified the transaction performs the right
operation, we need to extract the domain hash and the message hash to
approve.

Go back to the "Summary" tab, and find the
`GnosisSafe.checkSignatures` call. This call's `data` parameter
contains both the domain hash and the message hash that will show up
in your Ledger.

It will be a concatenation of `0x1901`, the domain hash, and the
message hash: `0x1901[domain hash][message hash]`.

Note down this value. You will need to compare it with the ones
displayed on the Ledger screen at signing.

### 4. Approve the signature on your ledger

Once the validations are done, it's time to actually sign the
transaction. Make sure your ledger is still unlocked and run the
following:

``` shell
make sign-op # or make sign-cb for Coinbase signers
```

> [!IMPORTANT] This is the most security critical part of the
> playbook: make sure the domain hash and message hash in the
> following two places match:

1. on your Ledger screen.
2. in the Tenderly simulation. You should use the same Tenderly
   simulation as the one you used to verify the state diffs, instead
   of opening the new one printed in the console.

There is no need to verify anything printed in the console. There is
no need to open the new Tenderly simulation link either.

After verification, sign the transaction. You will see the `Data`,
`Signer` and `Signature` printed in the console. Format should be
something like this:

```
Data:  <DATA>
Signer: <ADDRESS>
Signature: <SIGNATURE>
```

Double check that:
1. signer address is the right one.
2. domain hash and message hash match the ones you noted down.

## [For Facilitator ONLY] Execute the output

1. Collect outputs from all participating signers.
2. Concatenate all signatures and export it as the `SIGNATURES`
   environment variable, i.e. `export
   SIGNATURES="0x[SIGNATURE1][SIGNATURE2]..."`.
3. Run `make approve-cb` with Coinbase signer signatures.
4. Run `make approve-op` with Optimism signer signatures.
5. Run `make run` to execute the transaction onchain.
