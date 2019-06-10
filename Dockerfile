FROM elixir:1.8.1-alpine
RUN apk add inotify-tools

RUN mix local.hex --force
RUN mix local.rebar --force

RUN mkdir /app
COPY . /app
WORKDIR /app

RUN mix deps.get
