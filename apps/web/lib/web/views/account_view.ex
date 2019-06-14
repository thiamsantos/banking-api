defmodule Web.AccountView do
  use Web, :view

  def render("show.json", %{account: account}) do
    %{data: render_one(account, __MODULE__, "account.json")}
  end

  def render("account.json", %{account: account}) do
    %{id: account.id, email: account.email, balance: account.balance}
  end
end
