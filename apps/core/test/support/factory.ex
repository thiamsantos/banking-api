defmodule Core.Factory do
  use ExMachina.Ecto, repo: Core.Repo

  alias Core.Schemas.Account
  alias Core.SecurePassword

  def account_factory do
    %Account{
      email: Faker.Internet.email(),
      balance: 1_000,
      password: "password",
      encrypted_password: SecurePassword.digest("password")
    }
  end

  def with_password(%Account{} = account, password) do
    %{account | password: password, encrypted_password: SecurePassword.digest(password)}
  end
end
