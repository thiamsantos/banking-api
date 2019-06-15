defmodule Test do
  use Banking.DataCase, async: true

  alias Banking.Transfers
  alias Core.Repo
  alias Core.Schemas.{Account, Transaction}

  describe "create/1" do
    test "valid params" do
      origin_account = insert(:account, balance: 200)
      destination_account = insert(:account, balance: 200)

      params = %{
        from_account_id: origin_account.id,
        to_account_id: destination_account.id,
        amount: 100
      }

      {:ok, %Transaction{} = transaction} = Transfers.create(params)

      persisted_origin_account = Repo.get!(Account, origin_account.id)
      persisted_destination_account = Repo.get!(Account, destination_account.id)
      persisted_transaction = Repo.get_by!(Transaction, from_account_id: origin_account.id)

      assert persisted_transaction.id == transaction.id
      assert persisted_transaction.amount == 100
      assert persisted_transaction.from_account_id == origin_account.id
      assert persisted_transaction.to_account_id == destination_account.id
      assert persisted_transaction.type == :transfer

      assert persisted_destination_account.balance == 300
      assert persisted_origin_account.balance == 100
    end

    test "insufficient balance" do
      origin_account = insert(:account, balance: 50)
      destination_account = insert(:account, balance: 200)

      params = %{
        from_account_id: origin_account.id,
        to_account_id: destination_account.id,
        amount: 100
      }

      assert Transfers.create(params) == {:error, :insufficient_balance}
      assert Repo.get!(Account, origin_account.id).balance == origin_account.balance
      assert Repo.get!(Account, destination_account.id).balance == destination_account.balance
      assert Repo.aggregate(Transaction, :count, :id) == 0
    end

    test "invalid origin account" do
      destination_account = insert(:account, balance: 200)

      params = %{
        from_account_id: Ecto.UUID.generate(),
        to_account_id: destination_account.id,
        amount: 100
      }

      assert {:error, changeset} = Transfers.create(params)

      assert errors_on(changeset) == %{from_account_id: ["does not exist"]}
      assert Repo.get!(Account, destination_account.id).balance == destination_account.balance
      assert Repo.aggregate(Transaction, :count, :id) == 0
    end

    test "invalid destination account" do
      origin_account = insert(:account, balance: 200)

      params = %{
        from_account_id: origin_account.id,
        to_account_id: Ecto.UUID.generate(),
        amount: 100
      }

      assert {:error, changeset} = Transfers.create(params)

      assert errors_on(changeset) == %{to_account_id: ["does not exist"]}
      assert Repo.get!(Account, origin_account.id).balance == origin_account.balance
      assert Repo.aggregate(Transaction, :count, :id) == 0
    end

    test "debit entire balance" do
      origin_account = insert(:account, balance: 200)
      destination_account = insert(:account, balance: 200)

      params = %{
        from_account_id: origin_account.id,
        to_account_id: destination_account.id,
        amount: 200
      }

      {:ok, %Transaction{} = transaction} = Transfers.create(params)

      persisted_origin_account = Repo.get!(Account, origin_account.id)
      persisted_destination_account = Repo.get!(Account, destination_account.id)
      persisted_transaction = Repo.get_by!(Transaction, from_account_id: origin_account.id)

      assert persisted_transaction.id == transaction.id
      assert persisted_transaction.amount == 200
      assert persisted_transaction.from_account_id == origin_account.id
      assert persisted_transaction.to_account_id == destination_account.id
      assert persisted_transaction.type == :transfer

      assert persisted_destination_account.balance == 400
      assert persisted_origin_account.balance == 0
    end
  end
end
