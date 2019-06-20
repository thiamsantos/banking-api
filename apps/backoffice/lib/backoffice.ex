defmodule Backoffice do
  @moduledoc """
  Documentation for Backoffice.
  """

  defdelegate create_operator(params), to: Backoffice.Operators, as: :create
  defdelegate validate_credentials(params), to: Backoffice.Operators, as: :validate_credentials
  defdelegate one_operator_by_id(operator_id), to: Backoffice.Operators, as: :one_by_id
end
