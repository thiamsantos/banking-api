defmodule Web.SessionTokenController do
  use Web, :controller

  alias Web.BankingGuardian
  alias Web.SessionTokens.CreateParams

  action_fallback Web.FallbackController

  def create(conn, params) do
    with {:ok, credentials} <- CreateParams.parse(params),
         {:ok, account} <- Banking.validate_credentials(credentials),
         {:ok, session_token, _claims} <- BankingGuardian.encode_and_sign(account) do
      conn
      |> put_status(:created)
      |> render("show.json", session_token: session_token)
    end
  end
end
