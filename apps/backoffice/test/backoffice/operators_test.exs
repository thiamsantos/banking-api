defmodule Backoffice.OperatorsTest do
  use Backoffice.DataCase, async: true

  alias Backoffice.Operators
  alias Core.{Repo, SecurePassword}
  alias Core.Schemas.Operator

  describe "create/1" do
    test "required params" do
      {:error, changeset} = Operators.create(%{email: nil, password: nil})

      assert errors_on(changeset) == %{email: ["can't be blank"], password: ["can't be blank"]}
    end

    test "persist operator" do
      params = %{
        email: Faker.Internet.email(),
        password: "secure_password"
      }

      {:ok, operator} = Operators.create(params)

      persisted_operator = Repo.get(Operator, operator.id)

      assert persisted_operator.email == params[:email]

      assert SecurePassword.valid?(params[:password], persisted_operator.encrypted_password) ==
               true
    end

    test "invalid email" do
      params = %{
        email: "invalid",
        password: "secure_password"
      }

      {:error, changeset} = Operators.create(params)

      assert errors_on(changeset) == %{email: ["has invalid format"]}
    end

    test "password too short" do
      params = %{
        email: Faker.Internet.email(),
        password: "short"
      }

      {:error, changeset} = Operators.create(params)

      assert errors_on(changeset) == %{password: ["should be at least 12 character(s)"]}
    end
  end

  describe "one_by_id/1" do
    test "valid operator id" do
      operator = insert(:operator)
      {:ok, persisted_operator} = Operators.one_by_id(operator.id)

      assert persisted_operator.email == operator.email
      assert SecurePassword.valid?(operator.password, persisted_operator.encrypted_password)
    end

    test "operator not found" do
      fake_operator_id = Ecto.UUID.generate()

      assert Operators.one_by_id(fake_operator_id) == {:error, :not_found}
    end
  end

  describe "validate_credentials/1" do
    test "valid credentials" do
      operator = build(:operator) |> with_password("secure_password") |> insert()

      params = %{
        email: operator.email,
        password: "secure_password"
      }

      assert {:ok, %Operator{} = validated_operator} = Operators.validate_credentials(params)

      assert validated_operator.id == operator.id
    end

    test "email not found" do
      params = %{
        email: Faker.Internet.email(),
        password: "secure_password"
      }

      assert Operators.validate_credentials(params) == {:error, :invalid_email_or_password}
    end

    test "invalid password" do
      operator = build(:operator) |> with_password("secure_password") |> insert()
      params = %{email: operator.email, password: "another_password"}

      assert Operators.validate_credentials(params) == {:error, :invalid_email_or_password}
    end
  end
end
