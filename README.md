# Banking API

[![Build Status](https://travis-ci.com/thiamsantos/banking-api.svg?branch=master)](https://travis-ci.com/thiamsantos/banking-api)

Conceptual REST API to handle financial transaction like transfers and withdrawals.

## API

Checkout the REST API documentation at [API.md](API.md) .

## Setup (with docker)

These instructions will get you a copy of the project up and running on your
local machine for development and testing purposes in a docker environment.

### Prerequisites

- [Docker](https://www.docker.com/) 18 or superior (other versions may work as well)

### Installing

```sh
$ docker-compose up
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

## Setup (without docker)

These instructions will get you a copy of the project up and running on your
local machine for development and testing purposes without docker.

### Prerequisites

- [asdf](https://github.com/asdf-vm/asdf) v0.5.0 or superior (other versions may work as well).
- [asdf-elixir](https://github.com/asdf-vm/asdf-elixir)
- [asdf-erlang](https://github.com/asdf-vm/asdf-erlang)
- [postgres](https://www.postgresql.org/) 9.6

### Installing

```sh
# Install the versions of elixir and erlang defined at .tool-versions
$ asdf install
# Copy the default .env file and customize with your local database credentials
$ cp .env .env.local
# Copy the default .env for tests and customize with your local database credentials for testing
$ cp .env.test .env.local.test
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
$ mix format
# Run the formatter
$ mix credo
# Run credo
```

## Environment variables

This projects uses a custom dotenv implementation that loads the env vars from
dotenv files, before running each mix config file.

The following env vars are used:

- `PORT` - The port that the server will start. Ex: `4000`.
- `DATABASE_URL` - The database's url. Ex: `postgres://username:password@host/db_name`
- `SECRET_KEY_BASE` - A secret key used by Phoenix as a base to generate secrets for encrypting and signing data. Run `mix phx.gen.secret` to generate a new one.

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* [Phoenix](https://phoenixframework.org/) - Web framework
* [Ecto](https://github.com/elixir-ecto/ecto) - Database wrapper and data-mapper
* [Guardian](https://github.com/ueberauth/guardian) - Token based authentication library
