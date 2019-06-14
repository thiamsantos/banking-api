defmodule Web.Router do
  use Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Web do
    pipe_through :api

    post "/accounts", AccountController, :create
    post "/session_tokens", SessionTokenController, :create
  end
end
