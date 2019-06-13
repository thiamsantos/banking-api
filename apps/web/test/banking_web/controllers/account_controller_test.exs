defmodule Web.AccountControllerTest do
  use Web.ConnCase, async: true

  alias Core.{Repo, SecurePassword}
  alias Core.Schemas.Account

  describe "create/2" do
    test "create account", %{conn: conn} do
      email = Faker.Internet.email()

      params = %{
        email: email,
        password: "secure_password"
      }

      response =
        conn
        |> post("/api/accounts", params)
        |> json_response(200)

      assert %{
               "data" => %{
                 "id" => account_id,
                 "email" => ^email,
                 "balance" => 100_000
               }
             } = response

      account = Repo.get!(Account, account_id)

      assert account.email == email
      assert SecurePassword.valid?(params[:password], account.encrypted_password) == true
    end

    test "required params", %{conn: conn} do
      params = %{}

      response =
        conn
        |> post("/api/accounts", params)
        |> json_response(422)

      assert response == %{
               "errors" => %{
                 "email" => ["can't be blank"],
                 "password" => ["can't be blank"]
               }
             }
    end

    test "invalid email", %{conn: conn} do
      params = %{
        email: "invalid",
        password: "secure_password"
      }

      response =
        conn
        |> post("/api/accounts", params)
        |> json_response(422)

      assert response == %{
               "errors" => %{
                 "email" => ["has invalid format"]
               }
             }
    end

    test "password too short", %{conn: conn} do
      email = Faker.Internet.email()

      params = %{
        email: email,
        password: "invalid"
      }

      response =
        conn
        |> post("/api/accounts", params)
        |> json_response(422)

      assert response == %{
               "errors" => %{
                 "password" => ["should be at least 12 character(s)"]
               }
             }
    end
  end
end
