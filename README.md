# contract-deployments

This repo contains execution code and artifacts related to Base contract deployments.
For actual contract implementations, see [base-org/contracts](https://github.com/base-org/contracts).

### Setup

To execute a new task run one of the following commands
* For full new deployment (of L1 contracts related to Base): `make setup-deploy network=<network>`
* For contract calls, upgrades, or one-off contract deployments: `make setup-task network=<network> task=<task-name>`

Next, `cd` into the directory that was created for you and follow the steps in the `README` in that directory.

### Using the deploy template

* Specify the commit of [Optimism code](https://github.com/ethereum-optimism/optimism) and [Base contracts code](https://github.com/base-org/contracts)  you intend to use in the `.env` file
* `make deps`
* Fill in the `inputs/deploy-config.json` and `inputs/misc-config.json` files with the input variables for the deployment.
* See the example `make deploy` command. Modifications may need to be made if you're using a key for deployment that you do not have the private key for (e.g. a hardware wallet)
* Run `make deploy` command
* Check in files to github. The files to ignore should already have been specified in the `.gitignore`, so you should be able to check in everything.


### Using the generic template

This template can be used to do contract calls, upgrades or one-off deployments.
Specifically for contract ownership transfers, there is an example file `TransferOwner.s.sol`, which can be used to setup the ownership transfer task.

#### Directory structure

** [inputs/](/inputs) **  any input json files
** [records/](/records) ** foundry will autogenerate files here from running commands
** [script/](/script)  ** place to store any one-off foundry scripts
** [src/](/src) ** place to store any one-off smart contracts (long lived contracts should go in [base-org/contracts](https://github.com/base-org/contracts))
** .env ** place to store env variables specific to this task

#### Process

* Specify the commit of [Optimism code](https://github.com/ethereum-optimism/optimism) and [Base contracts code](https://github.com/base-org/contracts)  you intend to use in the `.env` file
* `make deps`
* See [forge script](https://book.getfoundry.sh/reference/forge/forge-script) documentation for how to use solidity scripts
* It's recommended to specify any addresses that are passed into scripts in the `.env` file, to make it easier for reviewers.
