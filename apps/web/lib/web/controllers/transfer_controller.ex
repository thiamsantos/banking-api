defmodule Web.TransferController do
  use Web, :controller

  alias Web.Transfers.CreateParams

  action_fallback Web.FallbackController

  def create(%Plug.Conn{assigns: %{current_account: current_account}} = conn, params) do
    with {:ok, create_params} <- CreateParams.parse(params),
         {:ok, transfer} <- create_transfer(current_account, create_params) do
      conn
      |> put_status(:created)
      |> render("show.json", transfer: transfer)
    end
  end

  defp create_transfer(current_account, params) do
    params
    |> Map.put(:from_account_id, current_account.id)
    |> Banking.create_transfer()
  end
end
