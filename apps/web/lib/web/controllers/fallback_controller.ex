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

  def call(conn, {:error, :invalid_email_or_password}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(Web.ErrorView)
    |> render("show.json", errors: %{email: ["Invalid email or password"]})
  end

  def call(conn, {:error, :insufficient_balance}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(Web.ErrorView)
    |> render("show.json", errors: %{balance: ["Insufficient balance"]})
  end

  def call(conn, {:error, reason}) do
    conn
    |> put_status(:internal_server_error)
    |> put_view(Web.ErrorView)
    |> render("show.json", errors: [to_string(reason)])
  end
end
