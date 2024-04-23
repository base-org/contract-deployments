# Migrate to Security Council on L2

Status: READY TO SIGN

## Objective

This task performs the migration from the 2/2 Nested Safe to the Security Council on Ethereum mainnet by udpating the ProxyAdmin [owner](https://etherscan.io/address/0x0475cBCAebd9CE8AfA5025828d5b98DFb67E059E#readContract#F6) from the [Nested Safe](https://etherscan.io/address/0x7bB41C3008B3f03FE483B28b8DB90e19Cf07595c#code) to the [DeleayedVetoable](TBD).

## Approving the transaction

### 1. Update repo and move to the appropriate folder:

```
cd contract-deployments
git pull
cd mainnet/2024-04-23-migrate-to-security-council
make deps
```

### 2. Setup Ledger

Your Ledger needs to be connected and unlocked. The Ethereum
application needs to be opened on Ledger with the message "Application
is ready".

### 3. Simulate and validate the transaction

Make sure your ledger is still unlocked and run the following.


``` shell
make sign-op-l2 # or make sign-cb-l2 for Coinbase signers
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

1. "Network": Check the network is Base Mainnet.
2. "Timestamp": Check the simulation is performed on a block with a
   recent timestamp (i.e. close to when you run the script).
3. "Sender": Check the address shown is your signer account. If not,
   you will need to determine which “number” it is in the list of
   addresses on your ledger.
4. "Success" with a green check mark 


#### 3.2. Validate correctness of the state diff.

Now click on the "State" tab. Verify that:

1. Verify that the nonce is incremented for the Nested Multisig under the "GnosisSafeProxy" at address `0x2304CB33d95999dC29f4CeF1e35065e670a70050`:

```
Key: 0x0000000000000000000000000000000000000000000000000000000000000005
Before: 0x0000000000000000000000000000000000000000000000000000000000000003
After: 0x0000000000000000000000000000000000000000000000000000000000000004
```

2. For the same contract, verify that this specific execution is approved:

```
Key (if you are an OP signer): 0xdeffc934ea69025de735812acd65795f23eb4298f10a9ab589aa248bd4158100
Key (if you are a CB signer): 0x06853935fddd4b1957d232ae52f6e2085b3b9ff565bd3f07300b8dfe55fa5ca3
Before: 0x0000000000000000000000000000000000000000000000000000000000000000
After: 0x0000000000000000000000000000000000000000000000000000000000000001
```

3. Verify that the nonce is incremented for your multisig:

If you are an OP signer - the OP Foundation Multisig should be under the "GnosisSafeProxy" at address `0x28edb11394eb271212ed66c08f2b7893c04c5d65`:

```
Key: 0x0000000000000000000000000000000000000000000000000000000000000005
Before: 0x0000000000000000000000000000000000000000000000000000000000000003
After: 0x0000000000000000000000000000000000000000000000000000000000000004
```

If you are a CB signer - the Coinbase Multisig should be under the address `0xd94e416cf2c7167608b2515b7e4102b41efff94f`:

```
Key: 0x0000000000000000000000000000000000000000000000000000000000000005
Before: 0x0000000000000000000000000000000000000000000000000000000000000006
After: 0x0000000000000000000000000000000000000000000000000000000000000007
```

4. Verify that the ProxyAdmin contract at address `0x4200000000000000000000000000000000000018` has its owner updated to the `DelayedVetoable` contract at address `0x000000000000000000000000000000000000cafe`:

```
Key: 0x0000000000000000000000000000000000000000000000000000000000000000
Before: 0x0000000000000000000000002304cb33d95999dc29f4cef1e35065e670a70050
After: 0x000000000000000000000000000000000000000000000000000000000000cafe
```

5. Verify that the L1FeeVault at `0x420000000000000000000000000000000000001a` receives the gas associated with the call:

```
Balance 2265189312213159486 -> 2265189469116205614
```

6. Verify that the nonce for the sending address is appropriately incremented:

```
Nonce 0 -> 1
```

#### 3.3. Extract the domain hash and the message hash to approve.

Now that we have verified the transaction performs the right
operation, we need to extract the domain hash and the message hash to
approve.

Go back to the "Overview" tab, and find the
`GnosisSafeL2.checkSignatures` call. This call's `data` parameter
contains both the domain hash and the message hash that will show up
in your Ledger.

Here is an example screenshot. Note that the hash value may be
different:

<img width="1195" alt="image" src="https://github.com/base-org/contract-deployments/assets/7411939/7d16806c-0408-4d5f-9212-bed4e6fc14f8">

It will be a concatenation of `0x1901`, the domain hash, and the
message hash: `0x1901[domain hash][message hash]`.

Note down this value. You will need to compare it with the ones
displayed on the Ledger screen at signing.

### 4. Approve the signature on your ledger

Once the validations are done, it's time to actually sign the
transaction. Make sure your ledger is still unlocked and run the
following:

``` shell
make sign-op-l2 # or make sign-cb-l2 for Coinbase signers
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

Double check the signer address is the right one.

### 5. Send the output to Facilitator(s)

Nothing has occurred onchain - these are offchain signatures which
will be collected by Facilitators for execution. Execution can occur
by anyone once a threshold of signatures are collected, so a
Facilitator will do the final execution for convenience.

Share the `Data`, `Signer` and `Signature` with the Facilitator, and
congrats, you are done!

## [For Facilitator ONLY] How to execute the rehearsal

### [After the rehearsal] Execute the output

1. Collect outputs from all participating signers.
2. Concatenate all signatures and export it as the `SIGNATURES`
   environment variable, i.e. `export
   SIGNATURES="0x[SIGNATURE1][SIGNATURE2]..."`.
3. Run `make approve-cb-l2` with Coinbase signer signatures.
4. Run `make approve-op-l2` with Optimism signer signatures.
4. Run `make execute-l2` to execute the transaction onchain.

