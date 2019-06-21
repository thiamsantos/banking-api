defmodule Web.Transfers.CreateParams do
  use Web.Params
  import Ecto.Changeset

  embedded_schema do
    field :to_account_id, Ecto.UUID
    field :amount, :integer
  end

  @fields [:to_account_id, :amount]

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
