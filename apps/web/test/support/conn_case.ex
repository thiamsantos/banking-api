defmodule Web.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias Web.Router.Helpers, as: Routes
      import Core.Factory
      import Swoosh.TestAssertions
      import Web.ConnCase

      # The default endpoint for testing
      @endpoint Web.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Core.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Core.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  def authenticate_account(conn, account) do
    {:ok, token, _claims} = Web.BankingGuardian.encode_and_sign(account)
    Plug.Conn.put_req_header(conn, "authorization", "Bearer #{token}")
  end

  def authenticate_operator(conn, operator) do
    {:ok, token, _claims} = Web.BackofficeGuardian.encode_and_sign(operator)
    Plug.Conn.put_req_header(conn, "authorization", "Bearer #{token}")
  end
end
