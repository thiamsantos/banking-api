defmodule Web.Backoffice.OperatorControllerTest do
  use Web.ConnCase, async: true

  alias Core.{Repo, SecurePassword}
  alias Core.Schemas.Operator

  describe "create/2" do
    test "create operator", %{conn: conn} do
      email = Faker.Internet.email()

      params = %{
        email: email,
        password: "secure_password"
      }

      response =
        conn
        |> post("/backoffice/operators", params)
        |> json_response(201)

      assert %{
               "data" => %{
                 "id" => operator_id,
                 "email" => ^email
               }
             } = response

      operator = Repo.get!(Operator, operator_id)

      assert operator.email == email
      assert SecurePassword.valid?(params[:password], operator.encrypted_password) == true
    end

    test "required params", %{conn: conn} do
      params = %{}

      response =
        conn
        |> post("/backoffice/operators", params)
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
        |> post("/backoffice/operators", params)
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
        |> post("/backoffice/operators", params)
        |> json_response(422)

      assert response == %{
               "errors" => %{
                 "password" => ["should be at least 12 character(s)"]
               }
             }
    end
  end
end
