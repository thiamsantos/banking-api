defmodule Core.Repo.Migrations.DropMustBePositiveConstraint do
  use Ecto.Migration

  def up do
    drop constraint(:accounts, :balance_must_be_positive)
  end

  def down do
    create constraint(:accounts, :balance_must_be_positive, check: "balance > 0")
  end
end
