defmodule Banking.Withdrawals do
  alias Banking.Accounts
  alias Banking.Accounts.Queries
  alias Banking.Withdrawals.Email
  alias Core.Repo
  alias Core.Schemas.Transaction
  alias Ecto.Multi

  def create(%{account_id: account_id, amount: amount}) do
    transaction_params = %{
      from_account_id: account_id,
      amount: amount
    }

    Multi.new()
    |> Multi.insert(
      :transaction,
      Transaction.changeset_withdrawal(%Transaction{}, transaction_params)
    )
    |> Multi.run(:balance_check, __MODULE__, :check_balance, [account_id, amount])
    |> Multi.update_all(:account, Queries.by_id_select_account(account_id),
      inc: [balance: -amount]
    )
    |> Multi.run(:email, __MODULE__, :send_create_email, [])
    |> Repo.transaction()
    |> handle_create()
  end

  def send_create_email(_repo, %{account: {1, [account | _]}, transaction: transaction}) do
    account
    |> Email.withdrawal_email(transaction)
    |> Core.Mailer.deliver()
  end

  def check_balance(_repo, _changes, account_id, amount) do
    if Accounts.has_enough_balance?(account_id, amount) do
      {:ok, account_id}
    else
      {:error, :insufficient_balance}
    end
  end

  defp handle_create({:ok, %{transaction: transaction}}) do
    {:ok, transaction}
  end

  defp handle_create({:error, :transaction, changeset, _changes}) do
    {:error, changeset}
  end

  defp handle_create({:error, :balance_check, reason, _changes}) do
    {:error, reason}
  end
end
