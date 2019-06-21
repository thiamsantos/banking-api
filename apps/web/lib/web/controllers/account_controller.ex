defmodule Web.AccountController do
  use Web, :controller

  alias Web.Accounts.CreateParams

  action_fallback Web.FallbackController

  def create(conn, params) do
    with {:ok, create_params} <- CreateParams.parse(params),
         {:ok, account} <- Banking.create_account(create_params) do
      conn
      |> put_status(:created)
      |> render("show.json", account: account)
    end
  end
end
