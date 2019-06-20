defmodule Banking do
  @moduledoc """
  Documentation for Banking.
  """

  defdelegate create_account(params), to: Banking.Accounts, as: :create
  defdelegate validate_credentials(params), to: Banking.Accounts, as: :validate_credentials
  defdelegate one_account_by_id(account_id), to: Banking.Accounts, as: :one_by_id
  defdelegate create_transfer(params), to: Banking.Transfers, as: :create
  defdelegate create_withdrawal(params), to: Banking.Withdrawals, as: :create

  defdelegate build_withdrawal_email(account, transaction),
    to: Banking.Withdrawals.Email,
    as: :withdrawal_email
end
