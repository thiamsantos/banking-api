defmodule Core.Repo.Migrations.AddTransactionsTable do
  use Ecto.Migration

  alias Core.Enums.TransactionType

  def change do
    create table(:banking_transactions) do
      add :type, TransactionType.type(), null: false
      add :amount, :bigint, null: false
      add :from_account_id, references(:accounts), null: false
      add :to_account_id, references(:accounts)
    end
  end
end
