defmodule Core.Schemas.Transaction do
  use Core.Schema
  import Ecto.Changeset
  alias Core.Enums.TransactionType
  alias Core.Schemas.Account

  schema "banking_transactions" do
    field :type, TransactionType
    field :amount, :integer
    belongs_to :from_account, Account
    belongs_to :to_account, Account

    timestamps()
  end

  @transfer_fields [:amount, :from_account_id, :to_account_id]

  def changeset_transfer(transaction, params \\ %{}) do
    transaction
    |> cast(params, @transfer_fields)
    |> validate_required(@transfer_fields)
    |> put_change(:type, :transfer)
    |> validate_number(:amount, greater_than: 0, message: "must be positive")
    |> foreign_key_constraint(:from_account_id)
    |> foreign_key_constraint(:to_account_id)
  end

  @withdrawal_fields [:amount, :from_account_id]

  def changeset_withdrawal(transaction, params \\ %{}) do
    transaction
    |> cast(params, @withdrawal_fields)
    |> validate_required(@withdrawal_fields)
    |> put_change(:type, :withdrawal)
    |> validate_number(:amount, greater_than: 0, message: "must be positive")
    |> foreign_key_constraint(:from_account_id)
  end
end
