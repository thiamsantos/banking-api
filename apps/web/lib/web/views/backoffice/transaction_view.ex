defmodule Web.Backoffice.TransactionView do
  use Web, :view

  def render("show.json", %{amount: amount}) do
    %{data: render_one(amount, __MODULE__, "amount.json", as: :amount)}
  end

  def render("amount.json", %{amount: amount}) do
    %{total_amount: amount.total_amount, count: amount.count}
  end
end
