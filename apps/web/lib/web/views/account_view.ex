defmodule Web.AccountView do
  use Web, :view

  def render("show.json", %{account: account}) do
    %{data: render_one(account, __MODULE__, "page.json")}
  end

  def render("page.json", %{account: account}) do
    %{id: account.id, email: account.email, balance: account.balance}
  end
end
