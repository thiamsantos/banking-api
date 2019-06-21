defmodule Web.WithdrawalControllerTest do
  use Web.ConnCase, async: true

  alias Core.Repo
  alias Core.Schemas.{Account, Transaction}

  describe "create/2" do
    test "require authentication", %{conn: conn} do
      response =
        conn
        |> post("/api/withdrawals", %{})
        |> json_response(401)

      assert response == %{"errors" => ["Invalid token"]}
    end

    test "create a transfer", %{conn: conn} do
      account = insert(:account, balance: 200)

      amount = 100
      from_account_id = account.id

      params = %{
        amount: amount
      }

      response =
        conn
        |> authenticate_account(account)
        |> post("/api/withdrawals", params)
        |> json_response(201)

      assert %{
               "data" => %{
                 "id" => transfer_id,
                 "from_account_id" => ^from_account_id,
                 "amount" => ^amount
               }
             } = response

      persisted_origin_account = Repo.get!(Account, account.id)
      persisted_transaction = Repo.get!(Transaction, transfer_id)

      assert persisted_transaction.amount == params[:amount]
      assert persisted_transaction.from_account_id == from_account_id
      assert persisted_transaction.type == :withdrawal
      assert persisted_transaction.to_account_id == nil

      assert persisted_origin_account.balance == 100
      assert_email_sent Banking.build_withdrawal_email(account, persisted_transaction)
    end

    test "insufficient balance", %{conn: conn} do
      account = insert(:account, balance: 50)

      params = %{
        amount: 100
      }

      response =
        conn
        |> authenticate_account(account)
        |> post("/api/withdrawals", params)
        |> json_response(422)

      assert response == %{"errors" => %{"balance" => ["Insufficient balance"]}}
    end
  end
end
