# contract-deployments

This repo contains execution code and artifacts related to Base contract deployments.
For actual contract implementations, see [base-org/contracts](https://github.com/base-org/contracts).

### Setup

To execute a new task run one of the following commands
* For full new deployment (of L1 contracts related to Base): `make setup-deploy network=<network>`
* For contract calls, upgrades, or one-off contract deployments: `make setup-task network=<network> task=<task-name>`

Next, `cd` into the directory that was created for you and follow the steps in the `README` in that directory.
