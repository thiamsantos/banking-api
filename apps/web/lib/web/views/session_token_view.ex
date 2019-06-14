defmodule Web.SessionTokenView do
  use Web, :view

  def render("show.json", %{session_token: session_token}) do
    %{data: render_one(session_token, __MODULE__, "session_token.json")}
  end

  def render("session_token.json", %{session_token: session_token}) do
    %{session_token: session_token}
  end
end
