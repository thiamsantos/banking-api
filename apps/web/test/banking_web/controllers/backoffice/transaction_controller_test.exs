defmodule Web.Backoffice.TransactionControllerTest do
  use Web.ConnCase, async: true

  describe "total_amount/2" do
    test "required auth", %{conn: conn} do
      response =
        conn
        |> get("/backoffice/transactions/amount")
        |> json_response(401)

      assert response == %{"errors" => ["Invalid token"]}
    end

    test "total", %{conn: conn} do
      operator = insert(:operator)

      insert(:transfer, amount: 100, inserted_at: ~N[2000-01-01 23:00:07])
      insert(:transfer, amount: 200, inserted_at: ~N[2000-01-02 23:00:07])
      insert(:transfer, amount: 300, inserted_at: ~N[2000-02-02 23:00:07])
      insert(:transfer, amount: 400, inserted_at: ~N[2000-05-02 23:00:07])

      response =
        conn
        |> authenticate_operator(operator)
        |> get("/backoffice/transactions/amount")
        |> json_response(200)

      assert response == %{
               "data" => %{
                 "total_amount" => 1000,
                 "count" => 4
               }
             }
    end

    test "year", %{conn: conn} do
      operator = insert(:operator)

      insert(:transfer, amount: 100, inserted_at: ~N[2000-01-01 00:00:00])
      insert(:transfer, amount: 200, inserted_at: ~N[2000-01-02 23:00:07])
      insert(:transfer, amount: 300, inserted_at: ~N[2000-02-02 23:00:07])
      insert(:transfer, amount: 400, inserted_at: ~N[2000-12-31 23:59:59])
      insert(:transfer, amount: 400, inserted_at: ~N[2001-12-31 23:59:59])

      response =
        conn
        |> authenticate_operator(operator)
        |> get("/backoffice/transactions/amount?year=2000")
        |> json_response(200)

      assert response == %{"data" => %{"total_amount" => 1000, "count" => 4}}
    end

    test "month", %{conn: conn} do
      operator = insert(:operator)

      insert(:transfer, amount: 100, inserted_at: ~N[2000-01-01 00:00:00])
      insert(:transfer, amount: 200, inserted_at: ~N[2000-01-31 23:59:59])
      insert(:transfer, amount: 300, inserted_at: ~N[2000-02-02 23:00:07])
      insert(:transfer, amount: 400, inserted_at: ~N[2000-05-02 23:00:07])

      response =
        conn
        |> authenticate_operator(operator)
        |> get("/backoffice/transactions/amount?year=2000&month=1")
        |> json_response(200)

      assert response == %{"data" => %{"total_amount" => 300, "count" => 2}}
    end

    test "day", %{conn: conn} do
      operator = insert(:operator)

      insert(:transfer, amount: 100, inserted_at: ~N[2000-01-01 00:00:00])
      insert(:transfer, amount: 100, inserted_at: ~N[2000-01-01 23:59:59])
      insert(:transfer, amount: 200, inserted_at: ~N[2000-01-02 23:00:07])
      insert(:transfer, amount: 300, inserted_at: ~N[2000-02-02 23:00:07])
      insert(:transfer, amount: 400, inserted_at: ~N[2000-05-02 23:00:07])

      response =
        conn
        |> authenticate_operator(operator)
        |> get("/backoffice/transactions/amount?year=2000&month=1&day=1")
        |> json_response(200)

      assert response == %{"data" => %{"total_amount" => 200, "count" => 2}}
    end

    test "no transactions in total", %{conn: conn} do
      operator = insert(:operator)

      response =
        conn
        |> authenticate_operator(operator)
        |> get("/backoffice/transactions/amount")
        |> json_response(200)

      assert response == %{
               "data" => %{
                 "total_amount" => 0,
                 "count" => 0
               }
             }
    end

    test "no transactions in year", %{conn: conn} do
      operator = insert(:operator)

      insert(:transfer, amount: 100, inserted_at: ~N[2000-01-01 00:00:00])
      insert(:transfer, amount: 200, inserted_at: ~N[2000-01-02 23:00:07])
      insert(:transfer, amount: 300, inserted_at: ~N[2000-02-02 23:00:07])
      insert(:transfer, amount: 400, inserted_at: ~N[2000-12-31 23:59:59])
      insert(:transfer, amount: 400, inserted_at: ~N[2001-12-31 23:59:59])

      response =
        conn
        |> authenticate_operator(operator)
        |> get("/backoffice/transactions/amount?year=2002")
        |> json_response(200)

      assert response == %{"data" => %{"total_amount" => 0, "count" => 0}}
    end

    test "no transactions in month", %{conn: conn} do
      operator = insert(:operator)

      insert(:transfer, amount: 100, inserted_at: ~N[2000-01-01 00:00:00])
      insert(:transfer, amount: 200, inserted_at: ~N[2000-01-31 23:59:59])
      insert(:transfer, amount: 300, inserted_at: ~N[2000-02-02 23:00:07])
      insert(:transfer, amount: 400, inserted_at: ~N[2000-05-02 23:00:07])

      response =
        conn
        |> authenticate_operator(operator)
        |> get("/backoffice/transactions/amount?year=2000&month=3")
        |> json_response(200)

      assert response == %{"data" => %{"total_amount" => 0, "count" => 0}}
    end

    test "no transactions in day", %{conn: conn} do
      operator = insert(:operator)

      insert(:transfer, amount: 100, inserted_at: ~N[2000-01-01 00:00:00])
      insert(:transfer, amount: 100, inserted_at: ~N[2000-01-01 23:59:59])
      insert(:transfer, amount: 200, inserted_at: ~N[2000-01-02 23:00:07])
      insert(:transfer, amount: 300, inserted_at: ~N[2000-02-02 23:00:07])
      insert(:transfer, amount: 400, inserted_at: ~N[2000-05-02 23:00:07])

      response =
        conn
        |> authenticate_operator(operator)
        |> get("/backoffice/transactions/amount?year=2000&month=1&day=3")
        |> json_response(200)

      assert response == %{"data" => %{"total_amount" => 0, "count" => 0}}
    end

    test "invalid year", %{conn: conn} do
      operator = insert(:operator)

      response =
        conn
        |> authenticate_operator(operator)
        |> get("/backoffice/transactions/amount?year=invalid")
        |> json_response(422)

      assert response == %{"errors" => %{"date" => ["Invalid date"]}}
    end

    test "missing year", %{conn: conn} do
      operator = insert(:operator)

      response =
        conn
        |> authenticate_operator(operator)
        |> get("/backoffice/transactions/amount?year=")
        |> json_response(422)

      assert response == %{"errors" => %{"date" => ["Invalid date"]}}
    end

    test "invalid month", %{conn: conn} do
      operator = insert(:operator)

      response =
        conn
        |> authenticate_operator(operator)
        |> get("/backoffice/transactions/amount?year=2000&month=invalid")
        |> json_response(422)

      assert response == %{"errors" => %{"date" => ["Invalid date"]}}
    end

    test "nonexistent month", %{conn: conn} do
      operator = insert(:operator)

      response =
        conn
        |> authenticate_operator(operator)
        |> get("/backoffice/transactions/amount?year=2000&month=13")
        |> json_response(422)

      assert response == %{"errors" => %{"date" => ["Invalid date"]}}
    end

    test "missing month", %{conn: conn} do
      operator = insert(:operator)

      response =
        conn
        |> authenticate_operator(operator)
        |> get("/backoffice/transactions/amount?year=2000&month=")
        |> json_response(422)

      assert response == %{"errors" => %{"date" => ["Invalid date"]}}
    end

    test "invalid day", %{conn: conn} do
      operator = insert(:operator)

      response =
        conn
        |> authenticate_operator(operator)
        |> get("/backoffice/transactions/amount?year=2000&month=1&day=invalid")
        |> json_response(422)

      assert response == %{"errors" => %{"date" => ["Invalid date"]}}
    end

    test "nonexistent day", %{conn: conn} do
      operator = insert(:operator)

      response =
        conn
        |> authenticate_operator(operator)
        |> get("/backoffice/transactions/amount?year=2000&month=1&day=32")
        |> json_response(422)

      assert response == %{"errors" => %{"date" => ["Invalid date"]}}
    end

    test "missing day", %{conn: conn} do
      operator = insert(:operator)

      response =
        conn
        |> authenticate_operator(operator)
        |> get("/backoffice/transactions/amount?year=2000&month=1&day=")
        |> json_response(422)

      assert response == %{"errors" => %{"date" => ["Invalid date"]}}
    end

    test "invalid date", %{conn: conn} do
      operator = insert(:operator)

      response =
        conn
        |> authenticate_operator(operator)
        |> get("/backoffice/transactions/amount?year=2000&month=2&day=30")
        |> json_response(422)

      assert response == %{"errors" => %{"date" => ["Invalid date"]}}
    end

    test "invalid params return total", %{conn: conn} do
      operator = insert(:operator)

      insert(:transfer, amount: 100, inserted_at: ~N[2000-01-01 23:00:07])
      insert(:transfer, amount: 200, inserted_at: ~N[2000-01-02 23:00:07])
      insert(:transfer, amount: 300, inserted_at: ~N[2000-02-02 23:00:07])
      insert(:transfer, amount: 400, inserted_at: ~N[2000-05-02 23:00:07])

      response =
        conn
        |> authenticate_operator(operator)
        |> get("/backoffice/transactions/amount?invalid=param")
        |> json_response(200)

      assert response == %{"data" => %{"count" => 4, "total_amount" => 1000}}
    end
  end
end
