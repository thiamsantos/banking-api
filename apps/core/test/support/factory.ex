defmodule Core.Factory do
  use ExMachina.Ecto, repo: Core.Repo

  alias Core.Schemas.{Account, Transaction}
  alias Core.SecurePassword

  def account_factory do
    %Account{
      email: Faker.Internet.email(),
      balance: 1_000,
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

  def with_password(%Account{} = account, password) do
    %{account | password: password, encrypted_password: SecurePassword.digest(password)}
  end
end
