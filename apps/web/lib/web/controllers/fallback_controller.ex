defmodule Web.FallbackController do
  use Web, :controller

  alias Web.ErrorHelpers

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    errors = Ecto.Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)

    conn
    |> put_status(:unprocessable_entity)
    |> put_view(Web.ErrorView)
    |> render("show.json", errors: errors)
  end
end
