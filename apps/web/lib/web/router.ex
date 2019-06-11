defmodule Web.Router do
  use Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Web do
    pipe_through :api

    get "/ping", PingController, :ping
  end
end
