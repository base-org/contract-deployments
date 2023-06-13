# Steps ran

* Saved Deployer key in .env and relevant private key in .env.local
* Saved L1 owner Safe address in .env
* Ran `make get-aliased-addr` to get the L2 aliased key, which then saved in .env as well
* Ran `deploy-test-increment` to deploy test contract
* Check owner and number variables on the deployed contract with `cast call <DEPLOYED_CONTRACT> --rpc-url <L2_RPC_URL> "owner()"`
* Try calling increment() with key that's not an owner and it should revert
* Ran `make call-increment` with correct owner key (repeated X times by different signers to reach threshold)
* Checked that increment worked by calling `cast call <DEPLOYED_CONTRACT> --rpc-url <L2_RPC_URL> "number()"` and seeing that number has increased to 1.

Tx hash of successful exec transaction: https://goerli.etherscan.io/tx/0xa4581554f159a8ede23494e408e279d1c48a06d7b88dd4309ed51861b67d9dba
