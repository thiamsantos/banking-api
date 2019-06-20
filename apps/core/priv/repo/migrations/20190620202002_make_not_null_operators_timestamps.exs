defmodule Core.Repo.Migrations.MakeNotNullOperatorsTimestamps do
  use Ecto.Migration

  def up do
    alter table(:operators) do
      modify :inserted_at, :naive_datetime, null: false
      modify :updated_at, :naive_datetime, null: false
    end
  end

  def down do
    alter table(:operators) do
      modify :inserted_at, :naive_datetime, null: true
      modify :updated_at, :naive_datetime, null: true
    end
  end
end
