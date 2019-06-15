defmodule Banking.Transfers do
  alias Banking.Accounts
  alias Banking.Accounts.Queries
  alias Core.Repo
  alias Core.Schemas.Transaction
  alias Ecto.Multi

  def create(
        %{from_account_id: from_account_id, to_account_id: to_account_id, amount: amount} = params
      ) do
    Multi.new()
    |> Multi.insert(
      :transaction,
      Transaction.changeset_transfer(%Transaction{}, params)
    )
    |> Multi.run(:balance_check, __MODULE__, :check_balance, [from_account_id, amount])
    |> Multi.update_all(:debit_origin_account, Queries.by_id(from_account_id),
      inc: [balance: -amount]
    )
    |> Multi.update_all(:credit_destination_account, Queries.by_id(to_account_id),
      inc: [balance: amount]
    )
    |> Repo.transaction()
    |> handle_multi_transaction()
  end

  def check_balance(_repo, _changes, account_id, amount) do
    if Accounts.has_enough_balance?(account_id, amount) do
      {:ok, account_id}
    else
      {:error, :insufficient_balance}
    end
  end

  defp handle_multi_transaction({:ok, %{transaction: transaction}}) do
    {:ok, transaction}
  end

  defp handle_multi_transaction({:error, :balance_check, reason, _changes}) do
    {:error, reason}
  end

  defp handle_multi_transaction({:error, :debit_origin_account, _reason, _changes}) do
    {:error, :failed_debit_origin_account}
  end

  defp handle_multi_transaction({:error, :credit_destination_account, _reason, _changes}) do
    {:error, :failed_credit_destination_account}
  end

  defp handle_multi_transaction({:error, :transaction, changeset, _changes}) do
    {:error, changeset}
  end
end
