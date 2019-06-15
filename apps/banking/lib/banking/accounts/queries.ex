defmodule Banking.Accounts.Queries do
  import Ecto.Query
  alias Core.Schemas.Account

  def by_id(account_id) do
    from(account in Account, where: account.id == ^account_id)
  end

  def by_id_with_enough_balance(account_id, amount) do
    account_id
    |> by_id()
    |> where([account], account.balance >= ^amount)
  end
end
