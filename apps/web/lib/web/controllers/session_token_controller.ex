defmodule Web.SessionTokenController do
  use Web, :controller

  alias Web.SessionTokens.CreateParams

  action_fallback Web.FallbackController

  def create(conn, params) do
    with {:ok, create_params} <- CreateParams.parse(params),
         {:ok, session_token} <- Banking.create_session_token(create_params) do
      render(conn, "show.json", session_token: session_token)
    end
  end
end
