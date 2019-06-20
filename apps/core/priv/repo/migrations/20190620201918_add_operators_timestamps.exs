defmodule Core.Repo.Migrations.AddOperatorsTimestamps do
  use Ecto.Migration

  def change do
    alter table(:operators) do
      add :inserted_at, :naive_datetime
      add :updated_at, :naive_datetime
    end
  end
end
