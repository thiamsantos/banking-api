defmodule Backoffice do
  @moduledoc """
  Documentation for Backoffice.
  """

  defdelegate create_operator(params), to: Backoffice.Operators, as: :create
end
