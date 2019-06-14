defmodule Web.AccountViewTest do
  use Web.ConnCase, async: true

  alias Web.AccountView

  describe "render/2" do
    test "show.json" do
      account = insert(:account)

      assert AccountView.render("show.json", account: account) == %{
               data: %{
                 balance: account.balance,
                 email: account.email,
                 id: account.id
               }
             }
    end
  end
end
