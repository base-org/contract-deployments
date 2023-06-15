PROJECT_DIR = $(network)/$(shell date +'%Y-%m-%d')-$(task)
DEPLOY_DIR = $(network)/$(shell date +'%Y-%m-%d')-deploy

# Run `make setup-task network=<network> task=<task>`
setup-task:
	cp -r setup-templates/template-generic $(PROJECT_DIR)
	touch $(PROJECT_DIR)/.gitmodules

# Run `make setup-deploy network=<network>`
setup-deploy:
	mkdir -p $(network) && cp -r setup-templates/template-deploy $(DEPLOY_DIR)
	touch $(DEPLOY_DIR)/.gitmodules
