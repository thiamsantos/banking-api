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

  def one_by_id(account_id) do
    Repo.get(Account, account_id)
  end

  def one_by_email(email) do
    case Repo.get_by(Account, email: email) do
      nil -> {:error, :not_found}
      %Account{} = account -> {:ok, account}
    end
  end
end
