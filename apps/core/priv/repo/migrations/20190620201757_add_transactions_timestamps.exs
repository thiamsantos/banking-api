defmodule Core.Repo.Migrations.AddTransactionsTimestamps do
  use Ecto.Migration

  def change do
    alter table(:banking_transactions) do
      add :inserted_at, :naive_datetime
      add :updated_at, :naive_datetime
    end
  end
end
