defmodule Core.Schemas.OperatorTest do
  use Core.DataCase, async: true

  alias Core.Schemas.Operator
  alias Core.{Repo, SecurePassword}

  describe "changeset/2" do
    test "required fields" do
      changeset = Operator.changeset(%Operator{}, %{})

      assert errors_on(changeset) == %{
               email: ["can't be blank"],
               password: ["can't be blank"]
             }
    end

    test "email cannot be larger than 255" do
      params = %{
        email: random_string(255) <> Faker.Internet.email(),
        password: "secure_password"
      }

      {:error, changeset} = %Operator{} |> Operator.changeset(params) |> Repo.insert()

      assert errors_on(changeset) == %{email: ["should be at most 255 character(s)"]}
    end

    test "email should be unique" do
      account = insert(:operator)

      params = %{
        email: account.email,
        password: "secure_password"
      }

      {:error, changeset} = %Operator{} |> Operator.changeset(params) |> Repo.insert()

      assert errors_on(changeset) == %{email: ["has already been taken"]}
    end

    test "email should contain @" do
      params = %{
        email: "email",
        password: "secure_password"
      }

      {:error, changeset} = %Operator{} |> Operator.changeset(params) |> Repo.insert()

      assert errors_on(changeset) == %{email: ["has invalid format"]}
    end

    test "password should be larger than 12" do
      params = %{
        email: Faker.Internet.email(),
        password: "password"
      }

      {:error, changeset} = %Operator{} |> Operator.changeset(params) |> Repo.insert()

      assert errors_on(changeset) == %{password: ["should be at least 12 character(s)"]}
    end

    test "password cannot be larger than 255" do
      params = %{
        email: Faker.Internet.email(),
        password: random_string(256)
      }

      {:error, changeset} = %Operator{} |> Operator.changeset(params) |> Repo.insert()

      assert errors_on(changeset) == %{password: ["should be at most 255 character(s)"]}
    end

    test "valid params" do
      params = %{
        email: Faker.Internet.email(),
        password: "secure_password"
      }

      {:ok, account} = %Operator{} |> Operator.changeset(params) |> Repo.insert()

      assert account.email == params[:email]
      assert SecurePassword.valid?("secure_password", account.encrypted_password) == true
    end
  end
end
