defmodule Web.SessionTokens.CreateParams do
  use Web.Params
  import Ecto.Changeset

  embedded_schema do
    field :email, :string
    field :password, :string
  end

  @fields [:email, :password]

  def parse(params) do
    %__MODULE__{}
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> apply_action(:insert)
  end
end
