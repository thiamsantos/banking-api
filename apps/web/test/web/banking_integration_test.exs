defmodule Web.BankingIntegrationTest do
  use Web.ConnCase, async: true

  test "integration happy path" do
    # create first account
    first_account_params = %{
      email: Faker.Internet.email(),
      password: "secure_password"
    }

    %{"data" => first_account} =
      build_conn()
      |> post("/api/accounts", first_account_params)
      |> json_response(200)

    assert first_account["email"] == first_account_params[:email]

    # create second account
    second_account_params = %{
      email: Faker.Internet.email(),
      password: "secure_password"
    }

    %{"data" => second_account} =
      build_conn()
      |> post("/api/accounts", second_account_params)
      |> json_response(200)

    assert second_account["email"] == second_account_params[:email]

    # create session token for first account
    response =
      build_conn()
      |> post("/api/session_tokens", first_account_params)
      |> json_response(200)

    assert %{"data" => %{"session_token" => first_account_session_token}} = response

    # transfer all balance from first account to second account
    params = %{
      to_account_id: second_account["id"],
      amount: 100_000
    }

    response =
      build_conn()
      |> put_req_header("authorization", "Bearer #{first_account_session_token}")
      |> post("/api/transfers", params)
      |> json_response(200)

    assert %{
             "data" => %{
               "from_account_id" => from_account_id,
               "to_account_id" => to_account_id,
               "amount" => amount
             }
           } = response

    assert from_account_id == first_account["id"]
    assert to_account_id == second_account["id"]
    assert amount == 100_000

    # create sesssion token for second account
    response =
      build_conn()
      |> post("/api/session_tokens", second_account_params)
      |> json_response(200)

    assert %{"data" => %{"session_token" => second_account_session_token}} = response

    # withdrawal all balance from second account
    params = %{
      amount: 100_000
    }

    response =
      build_conn()
      |> put_req_header("authorization", "Bearer #{second_account_session_token}")
      |> post("/api/withdrawals", params)
      |> json_response(200)

    assert %{
             "data" => %{
               "from_account_id" => from_account_id,
               "amount" => amount
             }
           } = response

    assert from_account_id == second_account["id"]
    assert amount == 100_000
  end
end
