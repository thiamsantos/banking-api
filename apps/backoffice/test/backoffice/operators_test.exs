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
end
