# Deploy Process

* Specify the commit of [Optimism code](https://github.com/ethereum-optimism/optimism) and [Base contracts code](https://github.com/base-org/contracts)  you intend to use in the `.env` file
* `make solidity-deps`
* Fill in the `inputs/deploy-config.json` and `inputs/misc-config.json` files with the input variables for the deployment.
* See the example `make deploy` command. Modifications may need to be made if you're using a key for deployment that you do not have the private key for (e.g. a hardware wallet)
* Run `make deploy` command
* Check in files to github. The files to ignore should already have been specified in the `.gitignore`, so you should be able to check in everything.
