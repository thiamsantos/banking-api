defmodule Web.Router do
  use Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected_api do
    plug Web.BankingAuthPlug
  end

  pipeline :protected_backoffice do
    plug Web.BackofficeAuthPlug
  end

  scope "/api", Web do
    pipe_through :api

    post "/accounts", AccountController, :create
    post "/session_tokens", SessionTokenController, :create

    scope "/transfers" do
      pipe_through :protected_api
      post "/", TransferController, :create
    end

    scope "/withdrawals" do
      pipe_through :protected_api
      post "/", WithdrawalController, :create
    end
  end

  scope "/backoffice", Web.Backoffice do
    pipe_through :api

    post "/operators", OperatorController, :create
    post "/session_tokens", SessionTokenController, :create

    scope "/transactions" do
      pipe_through :protected_backoffice

      get "/amount", TransactionController, :total_amount
    end
  end
end
