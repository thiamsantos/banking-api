defmodule Banking do
  @moduledoc """
  Documentation for Banking.
  """

  defdelegate create_account(params), to: Banking.Accounts, as: :create
  defdelegate validate_credentials(params), to: Banking.Accounts, as: :validate_credentials
  defdelegate create_transfer(params), to: Banking.Transfers, as: :create
  defdelegate create_withdrawal(params), to: Banking.Withdrawals, as: :create
end
