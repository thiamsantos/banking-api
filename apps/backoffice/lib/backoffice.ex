defmodule Backoffice do
  @moduledoc """
  Documentation for Backoffice.
  """

  defdelegate create_operator(params), to: Backoffice.Operators, as: :create
  defdelegate validate_credentials(params), to: Backoffice.Operators, as: :validate_credentials
end
