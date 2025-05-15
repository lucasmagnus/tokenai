# node-typescript

![The Cheesecake Labs](https://images.sympla.com.br/5d11137d98ce3.png)

## Description

This is the backend application developed in NodeJS.

## Requirements

Make sure you have all this installed:

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Make](https://formulae.brew.sh/formula/make)
- [Node JS](https://nodejs.org/en)

## Stack

This project uses the following stack:

- Node 18.x.x
- MariaDB
- Typescript
- ApolloServer
- Express
- TypeORM
- EsLint
- Jest

## Running application locally

### Setup env vars

To initially setup the local env vars, use the following command to copy the `.env.example` and create a new `.env.development` file
```bash
cp src/config/.env.example src/config/.env.development
```

Be aware to update the variable `db_host` to `localhost` if you wish to run the API without Docker

### Running with Docker
To run the project using Docker, run the following command:

```bash
make docker-start
```

### Running with Node JS

To run the project using Node JS, run the following command:

```bash
make docker-start-db DETACH=-d
make setup-dev
make dev
```

Run the migrations:
```bash
make migration-run
```

### Linting

Display the current linting problems:

```bash
make lint
```

Try to automatically fix them:

```bash
make lint-fix
```

### Running automated tests

Run the application tests:

```bash
make docker-start-db DETACH=-d
make setup-local-nodejs-env-test
make test
```

### Running code coverage tests

Run the code coverage tests:

```bash
make docker-start-db DETACH=-d
make setup-local-nodejs-env-test
make coverage-test
```

### Build the app

To generate a build to deploy the application:

```bash
make build
```

### More options

See `make help` for more options
