# Transfer and Delegate OP Tokens

Status: DRAFT, NOT READY TO SIGN

> [!IMPORTANT] !!! DO NOT SIGN using this playbook yet, as it has not
> been approved by all stakeholders

## Objective

When Base launched, Optimism granted a share of OP tokens to Coinbase. The token distribution occurs onchain, and vests over a period of 6 years, with the first vesting event in July 2024. A smart contract handles the logic to make the tokens available for distribution as they vest. This smart contract (the "Smart Escrow Contract") also receives OP tokens 1 year before they vest and stores them until vesting. However, since the Smart Escrow contract was not ready upon Base launch, the existing OP tokens are being stored in a 2-of-2 multisig with CB & OP signers (identical to the multisig used for Base's upgrade keys, except on the Optimism network). 

Now that the Smart Escrow contract is live, this task moves any existing OP tokens from the 2-of-2 multisig to the Smart Escrow contract.

The one caveat is that some amount of the tokens (the "upfront grant") is available to be used by Coinbase for governance purposes, and since the Smart Escrow contract does not support governance use cases, these tokens will remain in the 2-of-2 and be sent directly to Coinbase upon vesting in July 2024. In the menatime, we will do a 1 time delegation of these tokens to a Coinbase owned address, so they can be used for governance purposes prior to July. This delegation event is also handled in this signing task.

## Approving the transaction

### 1. Update repo and move to the appropriate folder:

```
cd contract-deployments
git pull
cd mainnet/2024-02-23-transfer-op
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

You will see a "Simulation link" from the output.

Paste this URL in your browser. A prompt may ask you to choose a
project, any project will do. You can create one if necessary.

Click "Simulate Transaction".

We will be performing 3 validations and extract the domain hash and
message hash to approve on your Ledger:

1. Validate integrity of the simulation.
2. Validate correctness of the state diff.
3. Validate and extract domain hash and message hash to approve.
4. Validate that the transaction completed successfully

#### 3.1. Validate integrity of the simulation.

Make sure you are on the "Overview" tab of the tenderly simulation, to
validate integrity of the simulation, we need to check the following:

1. "Network": Check the network is Optimism Mainnet.
2. "Timestamp": Check the simulation is performed on a block with a
   recent timestamp (i.e. close to when you run the script).
3. "Sender": Check the address shown is your signer account. If not,
   you will need to determine which “number” it is in the list of
   addresses on your ledger.
4. 


#### 3.2. Validate correctness of the state diff.

Now click on the "State" tab. Verify that:

1. TODO


#### 3.3. Extract the domain hash and the message hash to approve.

Now that we have verified the transaction performs the right
operation, we need to extract the domain hash and the message hash to
approve.

Go back to the "Overview" tab, and find the
`GnosisSafe.checkSignatures` call. This call's `data` parameter
contains both the domain hash and the message hash that will show up
in your Ledger.

Here is an example screenshot. Note that the hash value may be
different:

> TODO

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
3. Run `make approve-cb` with Coinbase signer signatures.
4. Run `make approve-op` with Optimism signer signatures.
4. Run `make run` to execute the transaction onchain.

