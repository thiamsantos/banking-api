defmodule Core.Repo.Migrations.AddAccountsTable do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :balance, :bigint, null: false
      add :email, :string, null: false, size: 255
      add :encrypted_password, :string, null: false, size: 60
    end

    create unique_index(:accounts, [:email])
    create constraint(:accounts, :balance_must_be_positive, check: "balance > 0")
  end
end
