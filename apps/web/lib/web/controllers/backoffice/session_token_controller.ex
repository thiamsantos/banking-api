defmodule Web.Backoffice.SessionTokenController do
  use Web, :controller

  alias Web.BackofficeGuardian
  alias Web.SessionTokens.CreateParams

  action_fallback Web.FallbackController

  def create(conn, params) do
    with {:ok, credentials} <- CreateParams.parse(params),
         {:ok, operator} <- Backoffice.validate_credentials(credentials),
         {:ok, session_token, _claims} <- BackofficeGuardian.encode_and_sign(operator) do
      conn
      |> put_view(Web.SessionTokenView)
      |> render("show.json", session_token: session_token)
    end
  end
end
