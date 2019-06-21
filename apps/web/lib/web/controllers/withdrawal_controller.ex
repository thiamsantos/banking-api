defmodule Web.WithdrawalController do
  use Web, :controller

  alias Web.Withdrawals.CreateParams

  action_fallback Web.FallbackController

  def create(%Plug.Conn{assigns: %{current_account: current_account}} = conn, params) do
    with {:ok, create_params} <- CreateParams.parse(params),
         {:ok, withdrawal} <- create_withdrawal(current_account, create_params) do
      conn
      |> put_status(:created)
      |> render("show.json", withdrawal: withdrawal)
    end
  end

  defp create_withdrawal(current_account, params) do
    params
    |> Map.put(:account_id, current_account.id)
    |> Banking.create_withdrawal()
  end
end
