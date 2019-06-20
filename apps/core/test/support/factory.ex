defmodule Core.Factory do
  use ExMachina.Ecto, repo: Core.Repo

  alias Core.Schemas.{Account, Operator, Transaction}
  alias Core.SecurePassword

  def account_factory do
    %Account{
      email: Faker.Internet.email(),
      balance: 1_000,
      password: "password",
      encrypted_password: SecurePassword.digest("password")
    }
  end

  def operator_factory do
    %Operator{
      email: Faker.Internet.email(),
      password: "password",
      encrypted_password: SecurePassword.digest("password")
    }
  end

  def withdrawal_factory do
    %Transaction{
      from_account: build(:account),
      amount: 100,
      type: :withdrawal
    }
  end

  def with_password(%r{} = resource, password) when r in [Account, Operator] do
    %{resource | password: password, encrypted_password: SecurePassword.digest(password)}
  end
end
