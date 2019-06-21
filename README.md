# Banking API

[![Build Status](https://travis-ci.com/thiamsantos/banking-api.svg?branch=master)](https://travis-ci.com/thiamsantos/banking-api)
[![Coverage Status](https://coveralls.io/repos/github/thiamsantos/banking-api/badge.svg?branch=master)](https://coveralls.io/github/thiamsantos/banking-api?branch=master)

Conceptual REST API to handle financial transaction like transfers and withdrawals.

## API

Checkout the REST API documentation at [API.md](API.md) .

## Setup (full docker)

These instructions will get you a copy of the project up and running on your
local machine for development and testing purposes in a docker environment.

### Prerequisites

- [Docker](https://www.docker.com/) 18 or superior (other versions may work as well)

### Installing

```sh
# change the DATABASE_URL to point to the container
$ echo "DATABASE_URL=postgres://postgres:postgres@database/banking" > .env.local
$ echo "DATABASE_URL=postgres://postgres:postgres@database/banking_test" > .env.local.test
$ docker-compose -f full-docker-compose.yml up
# The API will be available at localhost:4000
```

### Running the tests

```sh
$ make test
```

### Coding style tests

```sh
# Run the formatter
$ make format
# Run credo
$ make credo
```

## Setup (docker + mix)

These instructions will get you a copy of the project up and running on your
local machine for development and testing purposes without docker.

### Prerequisites

- [asdf](https://github.com/asdf-vm/asdf) v0.5.0 or superior (other versions may work as well).
- [asdf-elixir](https://github.com/asdf-vm/asdf-elixir)
- [asdf-erlang](https://github.com/asdf-vm/asdf-erlang)
- [Docker](https://www.docker.com/) 18 or superior (other versions may work as well)

### Installing

```sh
# Install the versions of elixir and erlang defined at .tool-versions
$ asdf install
# Start the database with docker
$ docker-compose up
# Create the databases
$ mix ecto.create
# Run the migrations
$ mix ecto.migrate
# Start the web server
$ mix phx.server
# The API will be available at localhost:4000
```

### Running the tests

```sh
$ mix test
```

### Coding style tests

```sh
# Run the formatter
$ mix format
# Run credo
$ mix credo
```

## Environment variables

This projects uses a custom dotenv implementation that loads the env vars from
dotenv files, before running each mix config file.

The following env vars are used:

* `PORT` - The port that the server will start. Ex: `4000`.
* `DATABASE_URL` - The database's url. Ex: `postgres://username:password@host/db_name`
* `POOL_SIZE` - The size of the pool of database connections. Ex: `2`.
* `SECRET_KEY_BASE` - A secret key used by Phoenix as a base to generate secrets for encrypting and signing data. Run `mix phx.gen.secret` to generate a new one.
* `HOST` - Application host. Ex: `banking.example.com`.
* `TIMBER_API_KEY` - [Timber](https://timber.io/) API key.
* `TIMBER_SOURCE_ID` - [Timber](https://timber.io/) source ID.
* `BANKING_SESSION_TOKEN_TTL_IN_MINUTES` - Time to live in minutes of the banking-related JWT session tokens. Ex: `15`
* `BANKING_SESSION_TOKEN_SECRET` - A secret key used by Guardiian to sign the banking-related JWT session tokens. Run `mix guardian.gen.secret` to generate a new one.
* `BACKOFFICE_SESSION_TOKEN_TTL_IN_MINUTES` - Time to live in minutes of the backoffice-related JWT session tokens. Ex: `15`
* `BACKOFFICE_SESSION_TOKEN_SECRET` - A secret key used by Guardiian to sign the backoffice-related JWT session tokens. Run `mix guardian.gen.secret` to generate a new one.
* `SENDGRID_API_KEY` - Sendgrid API key.

## Deployment (gigalixir)

**Requirements**

- [Gigalixir](https://www.gigalixir.com/) account
- [Gigalixir CLI](https://gigalixir.readthedocs.io/en/latest/main.html#getting-started-guide)
- [Timber](https://timber.io/) account
- Timber source created

**Steps**

```sh
# Login in your account
$ gigalixir login
# Create the app
$ APP_NAME=$(gigalixir create)
$ gigalixir pg:create --free
# Free tier db only allows 4 connections. Zero down-time deploys need pool_size*(n+1) connections.
$ gigalixir config:set POOL_SIZE=2
$ gigalixir config:set SECRET_KEY_BASE=$(mix phx.gen.secret)
$ gigalixir config:set HOST="$APP_NAME.gigalixirapp.com"
# Create a new source on timber
$ gigalixir config:set TIMBER_API_KEY="YOUR_API_KEY"
$ gigalixir config:set TIMBER_SOURCE_ID="YOUR_SOURCE_ID"
$ gigalixir config:set BANKING_SESSION_TOKEN_TTL_IN_MINUTES=15
$ gigalixir config:set BANKING_SESSION_TOKEN_SECRET=$(mix guardian.gen.secret)
$ gigalixir config:set BACKOFFICE_SESSION_TOKEN_TTL_IN_MINUTES=15
$ gigalixir config:set BACKOFFICE_SESSION_TOKEN_SECRET=$(mix guardian.gen.secret)
$ gigalixir config:set BANKING_WITHDRAWAL_FROM_EMAIL=youremail@example.com
$ gigalixir config:set SENDGRID_API_KEY="YOUR_API_KEY"
# Deploy the code
$ git push gigalixir master
```

**Continuous Delivery**

Since gigalixir deploys are just a normal git push, it should work with any CI/CD tool out there.

Export the following env vars on your CI/CD environment. The correct values can be found in the Gigalixir panel.

* `GIGALIXIR_EMAIL` - Ex: `foo%40gigalixir.com`.
* `GIGALIXIR_API_KEY` - Ex: `b9fbde22-fb73-4acb-8f74-f0aa6321ebf7`.
* `GIGALIXIR_APP_NAME` - Ex: `real-hasty-fruitbat`.

Then run:

```sh
$ git remote add gigalixir https://$GIGALIXIR_EMAIL:$GIGALIXIR_API_KEY@git.gigalixir.com/$GIGALIXIR_APP_NAME.git
$ git push -f gigalixir HEAD:refs/heads/master
```

A working example can be found at `.travis.yml`.

## Built With

* [Elixir](https://elixir-lang.org/) - Elixir programming language
* [PostgreSQL](https://www.postgresql.org/) - Relational database
* [Phoenix](https://phoenixframework.org/) - Web framework
* [Ecto](https://github.com/elixir-ecto/ecto) - Database wrapper and data-mapper
* [Guardian](https://github.com/ueberauth/guardian) - Token based authentication library
* [Swoosh](https://github.com/swoosh/swoosh) - Library used to compose, deliver and test emails.
* [Timber](https://timber.io/) - Logging service.
* [Sendgrid](https://sendgrid.com/) - Email delivery service.
