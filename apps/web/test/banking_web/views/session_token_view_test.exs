defmodule Web.SessionTokenViewTest do
  use Web.ConnCase, async: true

  alias Web.SessionTokenView

  describe "render/2" do
    test "show.json" do
      session_token = "session_token"

      assert SessionTokenView.render("show.json", session_token: session_token) == %{
               data: %{session_token: session_token}
             }
    end
  end
end
