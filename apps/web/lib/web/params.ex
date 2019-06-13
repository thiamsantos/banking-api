defmodule Web.Params do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema

      @primary_key false
    end
  end
end
