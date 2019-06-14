defmodule Banking do
  @moduledoc """
  Documentation for Banking.
  """

  defdelegate create_account(params), to: Banking.Accounts, as: :create
  defdelegate create_session_token(params), to: Banking.SessionTokens, as: :create
end
