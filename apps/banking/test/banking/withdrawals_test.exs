defmodule Banking.WithdrawalsTest do
  use Banking.DataCase, async: true

  alias Banking.Withdrawals
  alias Core.Repo
  alias Core.Schemas.{Account, Transaction}

  describe "create/1" do
    test "valid params" do
      account = insert(:account, balance: 200)
      params = %{account_id: account.id, amount: 100}

      {:ok, transaction} = Withdrawals.create(params)

      persisted_transaction = Repo.get!(Transaction, transaction.id)
      persisted_account = Repo.get!(Account, account.id)

      assert persisted_transaction.amount == params[:amount]
      assert persisted_transaction.from_account_id == params[:account_id]
      assert persisted_transaction.type == :withdrawal
      assert persisted_transaction.to_account_id == nil

      assert persisted_account.balance == 100

      assert_email_sent Withdrawals.Email.withdrawal_email(account, transaction)
    end

    test "invalid account" do
      params = %{account_id: Ecto.UUID.generate(), amount: 100}

      {:error, changeset} = Withdrawals.create(params)

      assert errors_on(changeset) == %{from_account_id: ["does not exist"]}

      assert Repo.aggregate(Transaction, :count, :id) == 0
      assert_no_email_sent()
    end

    test "insufficient balance" do
      account = insert(:account, balance: 200)
      params = %{account_id: account.id, amount: 300}

      assert Withdrawals.create(params) == {:error, :insufficient_balance}

      assert Repo.get!(Account, account.id).balance == account.balance
      assert Repo.aggregate(Transaction, :count, :id) == 0
      assert_no_email_sent()
    end

    test "debit entire balance" do
      account = insert(:account, balance: 200)
      params = %{account_id: account.id, amount: 200}

      {:ok, transaction} = Withdrawals.create(params)

      persisted_transaction = Repo.get!(Transaction, transaction.id)
      persisted_account = Repo.get!(Account, account.id)

      assert persisted_transaction.amount == params[:amount]
      assert persisted_transaction.from_account_id == params[:account_id]
      assert persisted_transaction.type == :withdrawal
      assert persisted_transaction.to_account_id == nil

      assert persisted_account.balance == 0

      assert_email_sent Withdrawals.Email.withdrawal_email(account, transaction)
    end
  end
end
