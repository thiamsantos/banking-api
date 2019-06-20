defmodule Web.TransferView do
  use Web, :view

  def render("show.json", %{transfer: transfer}) do
    %{data: render_one(transfer, __MODULE__, "transfer.json")}
  end

  def render("transfer.json", %{transfer: transfer}) do
    %{
      id: transfer.id,
      from_account_id: transfer.from_account_id,
      to_account_id: transfer.to_account_id,
      amount: transfer.amount
    }
  end
end
