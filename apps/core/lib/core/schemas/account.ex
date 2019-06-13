defmodule Core.Schemas.Account do
  use Core.Schema
  import Ecto.Changeset
  import Core.Changeset

  schema "accounts" do
    field :balance, :integer
    field :email, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string
  end

  @fields [:balance, :email, :password]

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> check_constraint(:balance, name: :balance_must_be_positive, message: "must be positive")
    |> validate_format(:email, ~r/@/)
    |> validate_length(:email, max: 255)
    |> unique_constraint(:email)
    |> validate_length(:password, min: 12, max: 255)
    |> put_encrypted_field(:password, :encrypted_password)
  end
end
