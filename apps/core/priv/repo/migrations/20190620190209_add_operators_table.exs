defmodule Core.Repo.Migrations.AddOperatorsTable do
  use Ecto.Migration

  def change do
    create table(:operators) do
      add :email, :string, null: false, size: 255
      add :encrypted_password, :string, null: false, size: 60
    end

    create unique_index(:operators, [:email])
  end
end
