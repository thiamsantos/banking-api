defmodule Web.PingController do
  use Web, :controller

  def ping(conn, _params) do
    json(conn, %{data: "pong"})
  end
end
