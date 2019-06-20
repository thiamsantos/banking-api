defmodule Core.Repo.Migrations.MakeNotNullTransactionsTimestamps do
  use Ecto.Migration

  def up do
    alter table(:banking_transactions) do
      modify :inserted_at, :naive_datetime, null: false
      modify :updated_at, :naive_datetime, null: false
    end
  end

  def down do
    alter table(:banking_transactions) do
      modify :inserted_at, :naive_datetime, null: true
      modify :updated_at, :naive_datetime, null: true
    end
  end
end
