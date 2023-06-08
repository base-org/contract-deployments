PROJECT_DIR = $(network)/$(shell date --iso=date)-$(task)
DEPLOY_DIR = $(network)/$(shell date --iso=date)-deploy

# Run `make setup-task network=<network> task=<task>`
setup-task:
	cp -r setup-templates/template-generic $(PROJECT_DIR)

# Run `make setup-deploy network=<network>`
setup-deploy:
	mkdir -p $(network) && cp -r setup-templates/template-deploy $(DEPLOY_DIR)