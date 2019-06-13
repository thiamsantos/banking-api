defmodule Banking do
  @moduledoc """
  Documentation for Banking.
  """

  defdelegate create_account(input), to: Banking.Accounts, as: :create
end
