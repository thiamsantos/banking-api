PROJECTNAME=$(shell basename "$(PWD)")
MAKEFLAGS += --silent

.PHONY: help
all: help
help: Makefile
	@echo
	@echo " Choose a command run in "$(PROJECTNAME)":"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo

## test - Run tests inside a docker container
test:
	docker-compose run -e MIX_ENV=test banking mix test

## format - Run the formatter inside a docker container
format:
	docker-compose run banking mix format