defmodule Core.Schemas.Operator do
  use Core.Schema
  import Ecto.Changeset
  import Core.Changeset

  schema "operators" do
    field :email, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string

    timestamps()
  end

  @fields [:email, :password]

  def changeset(account, params \\ %{}) do
    account
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:email, max: 255)
    |> unique_constraint(:email)
    |> validate_length(:password, min: 12, max: 255)
    |> put_encrypted_field(:password, :encrypted_password)
  end
end
