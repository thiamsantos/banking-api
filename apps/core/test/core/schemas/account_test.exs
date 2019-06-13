defmodule Core.Schemas.AccountTest do
  use Core.DataCase, async: true

  alias Core.Schemas.Account
  alias Core.{Repo, SecurePassword}

  describe "changeset/2" do
    test "required fields" do
      changeset = Account.changeset(%Account{}, %{})

      assert errors_on(changeset) == %{
               balance: ["can't be blank"],
               email: ["can't be blank"],
               password: ["can't be blank"]
             }
    end

    test "balance cannot be negative" do
      params = %{
        email: Faker.Internet.email(),
        balance: -1,
        password: "secure_password"
      }

      {:error, changeset} = %Account{} |> Account.changeset(params) |> Repo.insert()

      assert errors_on(changeset) == %{balance: ["must be positive"]}
    end

    test "email cannot be larger than 255" do
      params = %{
        email: random_string(255) <> Faker.Internet.email(),
        balance: 1_000,
        password: "secure_password"
      }

      {:error, changeset} = %Account{} |> Account.changeset(params) |> Repo.insert()

      assert errors_on(changeset) == %{email: ["should be at most 255 character(s)"]}
    end

    test "email should be unique" do
      account = insert(:account)

      params = %{
        email: account.email,
        balance: 1_000,
        password: "secure_password"
      }

      {:error, changeset} = %Account{} |> Account.changeset(params) |> Repo.insert()

      assert errors_on(changeset) == %{email: ["has already been taken"]}
    end

    test "email should contain @" do
      params = %{
        email: "email",
        balance: 1_000,
        password: "secure_password"
      }

      {:error, changeset} = %Account{} |> Account.changeset(params) |> Repo.insert()

      assert errors_on(changeset) == %{email: ["has invalid format"]}
    end

    test "password should be larger than 12" do
      params = %{
        email: Faker.Internet.email(),
        balance: 1_000,
        password: "password"
      }

      {:error, changeset} = %Account{} |> Account.changeset(params) |> Repo.insert()

      assert errors_on(changeset) == %{password: ["should be at least 12 character(s)"]}
    end

    test "password cannot be larger than 255" do
      params = %{
        email: Faker.Internet.email(),
        balance: 1_000,
        password: random_string(256)
      }

      {:error, changeset} = %Account{} |> Account.changeset(params) |> Repo.insert()

      assert errors_on(changeset) == %{password: ["should be at most 255 character(s)"]}
    end

    test "valid params" do
      params = %{
        email: Faker.Internet.email(),
        balance: 1_000,
        password: "secure_password"
      }

      {:ok, account} = %Account{} |> Account.changeset(params) |> Repo.insert()

      assert account.email == params[:email]
      assert account.balance == params[:balance]
      assert SecurePassword.valid?("secure_password", account.encrypted_password) == true
    end
  end
end
