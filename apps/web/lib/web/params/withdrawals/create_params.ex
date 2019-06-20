defmodule Web.Withdrawals.CreateParams do
  use Web.Params
  import Ecto.Changeset

  embedded_schema do
    field :amount, :integer
  end

  @fields [:amount]

  def parse(params) do
    %__MODULE__{}
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> apply_action(:insert)
    |> handle_parse()
  end

  defp handle_parse({:ok, struct}), do: {:ok, Map.from_struct(struct)}
  defp handle_parse({:error, reason}), do: {:error, reason}
end
