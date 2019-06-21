defmodule Web.BankingAuthPlugTest do
  use Web.ConnCase, async: true

  alias Core.Repo
  alias Guardian.Token.Jwt
  alias Web.{BackofficeGuardian, BankingAuthPlug, BankingGuardian}

  describe "call/2" do
    test "invalid jwt token", %{conn: conn} do
      invalid_token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"

      response =
        conn
        |> put_req_header("authorization", "Bearer #{invalid_token}")
        |> BankingAuthPlug.call([])
        |> json_response(401)

      assert response == %{"errors" => ["Invalid token"]}
    end

    test "backoffice's jwt token", %{conn: conn} do
      operator = insert(:operator)
      {:ok, token, _claims} = BackofficeGuardian.encode_and_sign(operator)

      response =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> BankingAuthPlug.call([])
        |> json_response(401)

      assert response == %{"errors" => ["Invalid token"]}
    end

    test "expired jwt token", %{conn: conn} do
      now = Timex.now()
      iat = now |> Timex.shift(minutes: -20) |> Timex.to_unix()
      exp = now |> Timex.shift(minutes: -5) |> Timex.to_unix()
      nbf = exp - 1

      account = insert(:account)

      claims = %{
        "aud" => "banking",
        "exp" => exp,
        "iat" => iat,
        "iss" => "banking",
        "jti" => Ecto.UUID.generate(),
        "nbf" => nbf,
        "sub" => account.id,
        "typ" => "access"
      }

      {:ok, token} = Jwt.create_token(BankingGuardian, claims)

      response =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> BankingAuthPlug.call([])
        |> json_response(401)

      assert response == %{"errors" => ["Invalid token"]}
    end

    test "token for deleted account", %{conn: conn} do
      account = insert(:account)
      {:ok, token, _claims} = BankingGuardian.encode_and_sign(account)

      Repo.delete!(account)

      response =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> BankingAuthPlug.call([])
        |> json_response(401)

      assert response == %{"errors" => ["Invalid token"]}
    end

    test "missing jwt token", %{conn: conn} do
      response =
        conn
        |> BankingAuthPlug.call([])
        |> json_response(401)

      assert response == %{"errors" => ["Invalid token"]}
    end

    test "malformed jwt token", %{conn: conn} do
      response =
        conn
        |> put_req_header("authorization", "Bearer malformed")
        |> BankingAuthPlug.call([])
        |> json_response(401)

      assert response == %{"errors" => ["Invalid token"]}
    end

    test "malformed authorization header", %{conn: conn} do
      response =
        conn
        |> put_req_header("authorization", "malformed")
        |> BankingAuthPlug.call([])
        |> json_response(401)

      assert response == %{"errors" => ["Invalid token"]}
    end
  end
end
