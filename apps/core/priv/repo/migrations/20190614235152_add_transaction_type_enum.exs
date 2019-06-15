defmodule Core.Repo.Migrations.AddTransactionTypeEnum do
  use Ecto.Migration

  alias Core.Enums.TransactionType

  def up do
    TransactionType.create_type()
  end

  def down do
    TransactionType.drop_type()
  end
end
