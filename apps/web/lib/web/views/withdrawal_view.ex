defmodule Web.WithdrawalView do
  use Web, :view

  def render("show.json", %{withdrawal: withdrawal}) do
    %{data: render_one(withdrawal, __MODULE__, "withdrawal.json")}
  end

  def render("withdrawal.json", %{withdrawal: withdrawal}) do
    %{
      id: withdrawal.id,
      from_account_id: withdrawal.from_account_id,
      amount: withdrawal.amount
    }
  end
end
