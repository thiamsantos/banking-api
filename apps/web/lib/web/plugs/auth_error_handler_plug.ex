defmodule Web.AuthErrorHandlerPlug do
  import Plug.Conn
  import Phoenix.Controller
  require Logger

  @behaviour Guardian.Plug.ErrorHandler

  def auth_error(conn, {type, reason}, _opts) do
    Logger.error(
      "[#{inspect(__MODULE__)}] Failed to authenticate request. Type: #{inspect(type)}. Reason: #{
        inspect(reason)
      }."
    )

    conn
    |> put_status(:unauthorized)
    |> put_view(Web.ErrorView)
    |> render("show.json", errors: ["Invalid token"])
  end
end
