# Steps ran

* Saved Deployer key in .env and relevant private key in .env.local
* Saved L1 owner Safe address in .env
* Ran `make get-aliased-addr` to get the L2 aliased key, which then saved in .env as well
* Ran `deploy-test-increment` to deploy test contract
* Check owner and number variables on the deployed contract with `cast call <DEPLOYED_CONTRACT> --rpc-url <L2_RPC_URL> "owner()"`
* Try calling increment() with key that's not an owner and it should revert
* Ran `make call-increment` with correct owner key