defmodule Web.SessionTokenControllerTest do
  use Web.ConnCase, async: true

  alias Banking.TokenIssuer

  describe "create/2" do
    test "valid params", %{conn: conn} do
      email = Faker.Internet.email()
      password = "secure_password"

      params = %{
        email: email,
        password: password
      }

      account = build(:account, email: email) |> with_password(password) |> insert()

      response =
        conn
        |> post("/api/session_tokens", params)
        |> json_response(200)

      assert %{"data" => %{"session_token" => session_token}} = response

      assert {:ok, %{"aud" => "banking", "sub" => sub, "typ" => "access"}} =
               TokenIssuer.decode_and_verify(session_token)

      assert sub == account.id
    end
  end

  test "required params", %{conn: conn} do
    response =
      conn
      |> post("/api/session_tokens", %{})
      |> json_response(422)

    assert response == %{
             "errors" => %{
               "email" => ["can't be blank"],
               "password" => ["can't be blank"]
             }
           }
  end

  test "email not found", %{conn: conn} do
    email = Faker.Internet.email()
    password = "secure_password"

    params = %{
      email: email,
      password: password
    }

    response =
      conn
      |> post("/api/session_tokens", params)
      |> json_response(422)

    assert response == %{"errors" => %{"email" => ["Invalid email or password"]}}
  end

  test "invalid password", %{conn: conn} do
    email = Faker.Internet.email()
    password = "secure_password"

    params = %{
      email: email,
      password: password
    }

    build(:account, email: email) |> with_password("different_password") |> insert()

    response =
      conn
      |> post("/api/session_tokens", params)
      |> json_response(422)

    assert response == %{"errors" => %{"email" => ["Invalid email or password"]}}
  end
end
