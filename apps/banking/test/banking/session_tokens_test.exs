defmodule Banking.SessionTokensTest do
  use Banking.DataCase, async: true

  alias Banking.{SessionTokens, TokenIssuer}

  describe "create/1" do
    test "valid params" do
      email = Faker.Internet.email()
      password = "secure_password"
      account = build(:account, email: email) |> with_password(password) |> insert()

      assert {:ok, session_token} = SessionTokens.create(%{email: email, password: password})

      assert {:ok, %{"aud" => "banking", "sub" => sub, "typ" => "access"}} =
               TokenIssuer.decode_and_verify(session_token)

      assert sub == account.id
    end

    test "email not found" do
      email = Faker.Internet.email()
      password = "secure_password"
      build(:account, email: email) |> with_password(password) |> insert()

      another_email = Faker.Internet.email()

      assert SessionTokens.create(%{email: another_email, password: password}) ==
               {:error, :invalid_email_or_password}
    end

    test "password invalid" do
      email = Faker.Internet.email()
      password = "secure_password"
      build(:account, email: email) |> with_password(password) |> insert()

      invalid_password = "invalid_password"

      assert SessionTokens.create(%{email: email, password: invalid_password}) ==
               {:error, :invalid_email_or_password}
    end
  end
end
