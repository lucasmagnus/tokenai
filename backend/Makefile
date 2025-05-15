#!make

help:
	@echo ""
	@echo "Usage:"
	@echo ""
	@echo "Setup, build and run (Docker):"
	@echo "  make docker-start          					Start the server and database docker containers"
	@echo "  make docker-stop          					Stop the server and database docker containers"
	@echo "  make docker-build						Build the docker containers"
	@echo "  make docker-start-web  					Start the server on a docker container"
	@echo "  make docker-stop-web   					Stop the server docker container"
	@echo "  make docker-start-db   					Start a database instance on a docker container"
	@echo "  make docker-stop-db    					Stop the database docker container"
	@echo ""
	@echo "Setup, build and run:"
	@echo "  make setup-dev						Setup the project including development dependencies"
	@echo "  make clean-setup-dev						Setup the project including development dependencies, cleaning all previous installed dependencies"
	@echo "  make clean-setup						Setup the project, cleaning all previous installed dependencies"
	@echo "  make build  	        					Compile the project typescript and generate the output bundles"
	@echo "  make start							Execute the builded code"
	@echo "  make dev							Start the server in development mode"
	@echo "  make setup-local-nodejs-env					Setup local development environment file"
	@echo "  make setup-local-nodejs-env-test					Setup local testing environment file"
	@echo ""
	@echo "Migrations and Seeds:"	
	@echo "  make migration-run        					Run the migrations"
	@echo "  make migration-revert       					Revert the migrations"
	@echo "  make migration-generate NAME={migration_name} 		Generate a new migration based on entities changes"
	@echo "  make docker-run-migration-run        				Run the migrations on the Node JS Docker container"
	@echo "  make docker-run-migration-revert       			Revert the migrations on the Node JS Docker container"
	@echo "  make docker-run-migration-generate NAME={migration_name} 	Generate a new migration based on entities changes on the Node JS Docker container"
	@echo ""
	@echo "Code Quality:"	
	@echo "  make lint  	         					Run the server linter"
	@echo "  make lint-fix  	         				Run the server linter with autofix flag activated"
	@echo "  make format-code        					Format the server code with prettier"
	@echo "  make test  	         					Run the server tests"
	@echo "  make coverage-test        					Run the server tests with code coverage"
	@echo ""
	@echo "Others:"
	@echo "  make docs          						Shows documentation"
	@echo ""

# Default variables

NODE_ENV ?= development
DEPLOY_STAGE ?= local
MAIN_CMD ?= npx ts-node-dev
BASE_DIR ?= ./src
COMPOSE ?= docker-compose
DETACH =

# Function to get the NODE_ENV if it is set
define GET_ENV
	ifdef NODE_ENV
		NODE_ENV=$(NODE_ENV)
	endif
endef

# Function to get the DEPLOY_STAGE if it is set
define GET_DEPLOY_STAGE
	ifdef DEPLOY_STAGE
		ifneq ("${DEPLOY_STAGE}","local")
			MAIN_CMD=node
			BASE_DIR=./dist
		endif
	endif
endef

# Docker

docker-start:
	$(COMPOSE) up $(DETACH)

docker-stop:
	$(COMPOSE) stop

docker-build:
	$(COMPOSE) build


# Requirements

setup-dev:
	npm install

clean-setup-dev:
	npm ci

clean-setup:
	npm ci --production

## Web

build:
	npx tsc -p tsconfig-build.json

start:
	NODE_PATH=./dist node dist/app.js

dev:
	DEPLOY_STAGE=local NODE_ENV=development NODE_PATH=./src npx ts-node-dev --trace-warnings --inspect --respawn --transpile-only --ignore-watch node_modules src/app.ts

docker-start-web:
	$(COMPOSE) up $(DETACH) nodejs

docker-stop-web:
	$(COMPOSE) stop nodejs


## Database

docker-start-db:
	$(COMPOSE) up $(DETACH) db

docker-stop-db:
	$(COMPOSE) stop db

migration-run:
	$(eval $(call GET_ENV))
	$(eval $(call GET_DEPLOY_STAGE))
	DEPLOY_STAGE=${DEPLOY_STAGE} NODE_ENV=${NODE_ENV} NODE_PATH=${BASE_DIR} ${MAIN_CMD} ./node_modules/typeorm/cli.js -d ${BASE_DIR}/config/database migration:run

migration-revert:
	$(eval $(call GET_ENV))
	$(eval $(call GET_DEPLOY_STAGE))
	DEPLOY_STAGE=${DEPLOY_STAGE} NODE_ENV=${NODE_ENV} NODE_PATH=${BASE_DIR} ${MAIN_CMD} ./node_modules/typeorm/cli.js -d ${BASE_DIR}/config/database migration:revert

migration-generate:
	$(eval $(call GET_ENV))
	$(eval $(call GET_DEPLOY_STAGE))
	DEPLOY_STAGE=${DEPLOY_STAGE} NODE_ENV=${NODE_ENV} NODE_PATH=${BASE_DIR} ${MAIN_CMD} ./node_modules/typeorm/cli.js -d ${BASE_DIR}/config/database migration:generate ${BASE_DIR}/api/core/migrations/$(NAME)

docker-run-migration-run:
	$(eval $(call GET_ENV))
	$(eval $(call GET_DEPLOY_STAGE))
	docker exec nodejs make migration-run NODE_ENV=${NODE_ENV} DEPLOY_STAGE=${DEPLOY_STAGE}

docker-run-migration-revert:
	$(eval $(call GET_ENV))
	$(eval $(call GET_DEPLOY_STAGE))
	docker exec nodejs make migration-revert NODE_ENV=${NODE_ENV} DEPLOY_STAGE=${DEPLOY_STAGE}

docker-run-migration-generate:
	$(eval $(call GET_ENV))
	$(eval $(call GET_DEPLOY_STAGE))
	docker exec nodejs make migration-generate NODE_ENV=${NODE_ENV} DEPLOY_STAGE=${DEPLOY_STAGE} NAME=${NAME}


## Code lint and format

lint:
	npx eslint src/

lint-fix:
	npx eslint src/ --fix

format-code:
	npx prettier --write src/**/*.{js,jsx,ts,tsx,json,md}


# Test

test:
	DEPLOY_STAGE=local NODE_ENV=test npx jest --config=./src/jest.config.js

coverage-test:
	DEPLOY_STAGE=local NODE_ENV=test npx jest --config=./src/jest.config.js --coverage


# Others

docs:
	./node_modules/.bin/apidoc -i src/ -o docs/

default: help
