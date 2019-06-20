defmodule Web.BankingAuthPlug do
  use Guardian.Plug.Pipeline,
    otp_app: :web,
    module: Web.BankingGuardian,
    error_handler: Web.AuthErrorHandlerPlug

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
  plug :put_resource

  def put_resource(conn, _opts) do
    resource = Guardian.Plug.current_resource(conn)

    assign(conn, :current_account, resource)
  end
end
