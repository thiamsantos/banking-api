defmodule Banking.Accounts do
  alias Banking.Accounts.Queries
  alias Core.{Repo, SecurePassword}
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
    case Repo.get(Account, account_id) do
      nil -> {:error, :not_found}
      %Account{} = account -> {:ok, account}
    end
  end

  def one_by_email(email) do
    case Repo.get_by(Account, email: email) do
      nil -> {:error, :not_found}
      %Account{} = account -> {:ok, account}
    end
  end

  def has_enough_balance?(account_id, amount) do
    account_id
    |> Queries.by_id_with_enough_balance(amount)
    |> Repo.exists?()
  end

  def validate_credentials(%{email: email, password: password}) do
    email
    |> one_by_email()
    |> validate_password(password)
  end

  defp validate_password({:error, _reason}, _), do: {:error, :invalid_email_or_password}

  defp validate_password({:ok, %Account{} = account}, password) do
    if SecurePassword.valid?(password, account.encrypted_password) do
      {:ok, account}
    else
      {:error, :invalid_email_or_password}
    end
  end
end
