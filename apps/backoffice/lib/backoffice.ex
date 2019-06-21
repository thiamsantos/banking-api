defmodule Backoffice do
  @moduledoc """
  Documentation for Backoffice.
  """

  defdelegate create_operator(params), to: Backoffice.Operators, as: :create
  defdelegate validate_credentials(params), to: Backoffice.Operators, as: :validate_credentials
  defdelegate one_operator_by_id(operator_id), to: Backoffice.Operators, as: :one_by_id
  defdelegate total_transactions_amount, to: Backoffice.Transactions, as: :total_amount

  defdelegate total_transactions_amount_by_year(year),
    to: Backoffice.Transactions,
    as: :total_amount_by_year

  defdelegate total_transactions_amount_by_month(year, month),
    to: Backoffice.Transactions,
    as: :total_amount_by_month

  defdelegate total_transactions_amount_by_day(date),
    to: Backoffice.Transactions,
    as: :total_amount_by_day
end
