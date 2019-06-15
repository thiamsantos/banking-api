defmodule Core.Schemas.TransactionTest do
  use Core.DataCase, async: true

  alias Core.Schemas.Transaction
  alias Core.Repo

  describe "changeset_transfer/2" do
    test "valid params" do
      origin_account = insert(:account)
      destination_account = insert(:account)

      params = %{
        amount: 1_000,
        from_account_id: origin_account.id,
        to_account_id: destination_account.id
      }

      {:ok, transaction} =
        %Transaction{}
        |> Transaction.changeset_transfer(params)
        |> Repo.insert()

      persisted_transaction = Repo.get!(Transaction, transaction.id)

      assert persisted_transaction.from_account_id == origin_account.id
      assert persisted_transaction.to_account_id == destination_account.id
      assert persisted_transaction.amount == params[:amount]
      assert persisted_transaction.type == :transfer
    end

    test "negative amount" do
      origin_account = insert(:account)
      destination_account = insert(:account)

      params = %{
        amount: -1,
        from_account_id: origin_account.id,
        to_account_id: destination_account.id
      }

      {:error, changeset} =
        %Transaction{}
        |> Transaction.changeset_transfer(params)
        |> Repo.insert()

      assert errors_on(changeset) == %{amount: ["must be positive"]}
    end

    test "invalid origin account" do
      destination_account = insert(:account)

      params = %{
        amount: 1_000,
        from_account_id: Ecto.UUID.generate(),
        to_account_id: destination_account.id
      }

      {:error, changeset} =
        %Transaction{}
        |> Transaction.changeset_transfer(params)
        |> Repo.insert()

      assert errors_on(changeset) == %{from_account_id: ["does not exist"]}
    end

    test "invalid destination account" do
      origin_account = insert(:account)

      params = %{
        amount: 1_000,
        from_account_id: origin_account.id,
        to_account_id: Ecto.UUID.generate()
      }

      {:error, changeset} =
        %Transaction{}
        |> Transaction.changeset_transfer(params)
        |> Repo.insert()

      assert errors_on(changeset) == %{to_account_id: ["does not exist"]}
    end

    test "required params" do
      params = %{}

      {:error, changeset} =
        %Transaction{}
        |> Transaction.changeset_transfer(params)
        |> Repo.insert()

      assert errors_on(changeset) == %{
               from_account_id: ["can't be blank"],
               amount: ["can't be blank"],
               to_account_id: ["can't be blank"]
             }
    end
  end

  describe "changeset_withdrawal/2" do
    test "valid params" do
      origin_account = insert(:account)

      params = %{
        amount: 1_000,
        from_account_id: origin_account.id
      }

      {:ok, transaction} =
        %Transaction{}
        |> Transaction.changeset_withdrawal(params)
        |> Repo.insert()

      persisted_transaction = Repo.get!(Transaction, transaction.id)

      assert persisted_transaction.from_account_id == origin_account.id
      assert persisted_transaction.to_account_id == nil
      assert persisted_transaction.amount == params[:amount]
      assert persisted_transaction.type == :withdrawal
    end

    test "required fields" do
      params = %{}

      {:error, changeset} =
        %Transaction{}
        |> Transaction.changeset_withdrawal(params)
        |> Repo.insert()

      assert errors_on(changeset) == %{
               from_account_id: ["can't be blank"],
               amount: ["can't be blank"]
             }
    end

    test "negative amount" do
      origin_account = insert(:account)

      params = %{
        amount: -1,
        from_account_id: origin_account.id
      }

      {:error, changeset} =
        %Transaction{}
        |> Transaction.changeset_withdrawal(params)
        |> Repo.insert()

      assert errors_on(changeset) == %{amount: ["must be positive"]}
    end

    test "invalid origin account" do
      params = %{
        amount: 1_000,
        from_account_id: Ecto.UUID.generate()
      }

      {:error, changeset} =
        %Transaction{}
        |> Transaction.changeset_withdrawal(params)
        |> Repo.insert()

      assert errors_on(changeset) == %{from_account_id: ["does not exist"]}
    end
  end
end
