defmodule Banking.AccountsTest do
  use Banking.DataCase, async: true

  alias Banking.Accounts
  alias Core.{Repo, SecurePassword}
  alias Core.Schemas.Account

  describe "create/1" do
    test "required params" do
      {:error, changeset} = Accounts.create(%{email: nil, password: nil})

      assert errors_on(changeset) == %{email: ["can't be blank"], password: ["can't be blank"]}
    end

    test "default balance of R$ 1000,00" do
      params = %{
        email: Faker.Internet.email(),
        password: "secure_password"
      }

      {:ok, account} = Accounts.create(params)

      assert account.balance == 100_000
    end

    test "persist account" do
      params = %{
        email: Faker.Internet.email(),
        password: "secure_password"
      }

      {:ok, account} = Accounts.create(params)

      persisted_account = Repo.get(Account, account.id)

      assert persisted_account.email == params[:email]

      assert SecurePassword.valid?(params[:password], persisted_account.encrypted_password) ==
               true
    end

    test "invalid email" do
      params = %{
        email: "invalid",
        password: "secure_password"
      }

      {:error, changeset} = Accounts.create(params)

      assert errors_on(changeset) == %{email: ["has invalid format"]}
    end

    test "password too short" do
      params = %{
        email: Faker.Internet.email(),
        password: "short"
      }

      {:error, changeset} = Accounts.create(params)

      assert errors_on(changeset) == %{password: ["should be at least 12 character(s)"]}
    end
  end
end
