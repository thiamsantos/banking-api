defmodule Web.TransferControllerTest do
  use Web.ConnCase, async: true

  alias Core.Repo
  alias Core.Schemas.{Account, Transaction}

  describe "create/2" do
    test "require authentication", %{conn: conn} do
      response =
        conn
        |> post("/api/transfers", %{})
        |> json_response(401)

      assert response == %{"errors" => ["Invalid token"]}
    end

    test "create a transfer", %{conn: conn} do
      origin_account = insert(:account, balance: 200)
      destination_account = insert(:account, balance: 200)

      amount = 100
      from_account_id = origin_account.id
      to_account_id = destination_account.id

      params = %{
        to_account_id: to_account_id,
        amount: amount
      }

      response =
        conn
        |> authenticate_account(origin_account)
        |> post("/api/transfers", params)
        |> json_response(200)

      assert %{
               "data" => %{
                 "id" => transfer_id,
                 "from_account_id" => ^from_account_id,
                 "to_account_id" => ^to_account_id,
                 "amount" => ^amount
               }
             } = response

      persisted_origin_account = Repo.get!(Account, origin_account.id)
      persisted_destination_account = Repo.get!(Account, destination_account.id)
      persisted_transaction = Repo.get!(Transaction, transfer_id)

      assert persisted_transaction.amount == 100
      assert persisted_transaction.from_account_id == origin_account.id
      assert persisted_transaction.to_account_id == destination_account.id
      assert persisted_transaction.type == :transfer

      assert persisted_destination_account.balance == 300
      assert persisted_origin_account.balance == 100
    end

    test "invalid params", %{conn: conn} do
      origin_account = insert(:account, balance: 200)

      params = %{}

      response =
        conn
        |> authenticate_account(origin_account)
        |> post("/api/transfers", params)
        |> json_response(422)

      assert response == %{
               "errors" => %{
                 "amount" => ["can't be blank"],
                 "to_account_id" => ["can't be blank"]
               }
             }
    end

    test "insufficient balance", %{conn: conn} do
      origin_account = insert(:account, balance: 0)
      destination_account = insert(:account, balance: 200)

      amount = 100

      params = %{
        to_account_id: destination_account.id,
        amount: amount
      }

      response =
        conn
        |> authenticate_account(origin_account)
        |> post("/api/transfers", params)
        |> json_response(422)

      assert response == %{"errors" => %{"balance" => ["Insufficient balance"]}}
    end

    test "invalid destination account", %{conn: conn} do
      origin_account = insert(:account, balance: 200)

      amount = 100
      to_account_id = Ecto.UUID.generate()

      params = %{
        to_account_id: to_account_id,
        amount: amount
      }

      response =
        conn
        |> authenticate_account(origin_account)
        |> post("/api/transfers", params)
        |> json_response(422)

      assert response == %{"errors" => %{"to_account_id" => ["does not exist"]}}
    end
  end
end
