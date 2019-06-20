defmodule Core.Repo.Migrations.PopulateAccountsTimestamps do
  use Ecto.Migration

  def up do
    execute """
      UPDATE
        accounts
      SET
        inserted_at = NOW(),
        updated_at = NOW()
      WHERE
        inserted_at IS NULL
        OR updated_at IS NULL;
    """
  end

  def down do
  end
end
