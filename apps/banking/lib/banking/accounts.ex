defmodule Banking.Accounts do
  alias Core.Repo
  alias Core.Schemas.Account

  def create(%{email: email, password: password}) do
    params = %{
      email: email,
      password: password,
      balance: 100_000
    }

    %Account{}
    |> Account.changeset(params)
    |> Repo.insert()
  end
end
