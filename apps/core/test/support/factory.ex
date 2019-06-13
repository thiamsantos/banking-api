defmodule Core.Factory do
  use ExMachina.Ecto, repo: Core.Repo

  alias Core.Schemas.Account

  def account_factory do
    %Account{
      email: Faker.Internet.email(),
      balance: 1_000,
      password: "password",
      encrypted_password: "password"
    }
  end
end
