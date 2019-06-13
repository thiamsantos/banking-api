defmodule Core.Changeset do
  import Ecto.Changeset

  alias Core.SecurePassword

  def put_encrypted_field(changeset, from_field, to_field) do
    if changeset.valid? do
      encrypted_value =
        changeset
        |> get_change(from_field)
        |> SecurePassword.digest()

      put_change(changeset, to_field, encrypted_value)
    else
      changeset
    end
  end
end
