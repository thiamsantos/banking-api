defmodule Web.Backoffice.SessionTokenControllerTest do
  use Web.ConnCase, async: true

  alias Web.BackofficeGuardian

  describe "create/2" do
    test "valid params", %{conn: conn} do
      email = Faker.Internet.email()
      password = "secure_password"

      params = %{
        email: email,
        password: password
      }

      operator = build(:operator, email: email) |> with_password(password) |> insert()

      response =
        conn
        |> post("/backoffice/session_tokens", params)
        |> json_response(201)

      assert %{"data" => %{"session_token" => session_token}} = response

      assert {:ok, %{"aud" => "backoffice", "sub" => sub, "typ" => "access"}} =
               BackofficeGuardian.decode_and_verify(session_token)

      assert sub == operator.id
    end

    test "required params", %{conn: conn} do
      response =
        conn
        |> post("/backoffice/session_tokens", %{})
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
        |> post("/backoffice/session_tokens", params)
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

      build(:operator, email: email) |> with_password("different_password") |> insert()

      response =
        conn
        |> post("/backoffice/session_tokens", params)
        |> json_response(422)

      assert response == %{"errors" => %{"email" => ["Invalid email or password"]}}
    end
  end
end
