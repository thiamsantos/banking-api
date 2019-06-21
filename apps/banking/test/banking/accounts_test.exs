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

  describe "one_by_id/1" do
    test "valid account id" do
      account = insert(:account)
      {:ok, persisted_account} = Accounts.one_by_id(account.id)

      assert persisted_account.email == account.email
      assert persisted_account.balance == account.balance
      assert SecurePassword.valid?(account.password, persisted_account.encrypted_password)
    end

    test "account not found" do
      fake_account_id = Ecto.UUID.generate()

      assert Accounts.one_by_id(fake_account_id) == {:error, :not_found}
    end
  end

  describe "has_enough_balance?/2" do
    test "account no found" do
      fake_account_id = Ecto.UUID.generate()
      assert Accounts.has_enough_balance?(fake_account_id, 1000) == false
    end

    test "without enough balance" do
      account = insert(:account, balance: 100)
      assert Accounts.has_enough_balance?(account.id, 1000) == false
    end

    test "with exact balance" do
      account = insert(:account, balance: 1000)
      assert Accounts.has_enough_balance?(account.id, 1000) == true
    end

    test "with enough balance" do
      account = insert(:account, balance: 2000)
      assert Accounts.has_enough_balance?(account.id, 1000) == true
    end
  end

  describe "validate_credentials/2" do
    test "valid credentials" do
      account = build(:account) |> with_password("secure_password") |> insert()

      params = %{
        email: account.email,
        password: "secure_password"
      }

      assert {:ok, %Account{} = validated_operator} = Accounts.validate_credentials(params)

      assert validated_operator.id == account.id
    end

    test "email not found" do
      params = %{
        email: Faker.Internet.email(),
        password: "secure_password"
      }

      assert Accounts.validate_credentials(params) == {:error, :invalid_email_or_password}
    end

    test "invalid password" do
      account = build(:account) |> with_password("secure_password") |> insert()
      params = %{email: account.email, password: "another_password"}

      assert Accounts.validate_credentials(params) == {:error, :invalid_email_or_password}
    end
  end
end
