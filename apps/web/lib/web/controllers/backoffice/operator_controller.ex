defmodule Web.Backoffice.OperatorController do
  use Web, :controller

  alias Web.Operators.CreateParams

  action_fallback Web.FallbackController

  def create(conn, params) do
    with {:ok, create_params} <- CreateParams.parse(params),
         {:ok, operator} <- Backoffice.create_operator(create_params) do
      conn
      |> put_status(:created)
      |> render("show.json", operator: operator)
    end
  end
end
