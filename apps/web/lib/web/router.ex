defmodule Web.Router do
  use Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected_api do
    plug Web.BankingAuthPlug
  end

  scope "/api", Web do
    pipe_through :api

    post "/accounts", AccountController, :create
    post "/session_tokens", SessionTokenController, :create

    scope "/transfers" do
      pipe_through :protected_api
      post "/", TransferController, :create
    end
  end
end
