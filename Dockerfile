FROM bitwalker/alpine-elixir:1.8.1
RUN apk add inotify-tools

RUN mkdir /app
COPY . /app
WORKDIR /app

RUN mix deps.get
