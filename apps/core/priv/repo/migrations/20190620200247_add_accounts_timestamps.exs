defmodule Core.Repo.Migrations.AddAccountsTimestamps do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add :inserted_at, :naive_datetime
      add :updated_at, :naive_datetime
    end
  end
end
