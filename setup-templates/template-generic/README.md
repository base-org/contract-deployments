# Generic template

This directory can be used to do contract calls, upgrades or one-off deployments

### Directory structure

** [inputs/](/inputs) **  any input json files
** [records/](/records) ** foundry will autogenerate files here from running commands
** [script/](/script)  ** place to store any one-off foundry scripts (long lived scripts should go in [base-org/contracts](https://github.com/base-org/contracts))
** [src/](/src) ** place to store any one-off smart contracts (long lived contracts should go in [base-org/contracts](https://github.com/base-org/contracts))
** .env ** place to store env variables specific to this task

### Process

* Specify the commit of [Optimism code](https://github.com/ethereum-optimism/optimism) and [Base contracts code](https://github.com/base-org/contracts)  you intend to use in the `.env` file
* See [forge script](https://book.getfoundry.sh/reference/forge/forge-script) documentation for how to use solidity scripts
* It's recommended to specify any addresses that are passed into scripts in the `.env` file, to make it easier for reviewers.
