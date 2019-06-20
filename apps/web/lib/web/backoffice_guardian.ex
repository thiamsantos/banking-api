defmodule Web.BackofficeGuardian do
  use Guardian, otp_app: :web

  alias Core.Schemas.Operator

  def subject_for_token(%Operator{} = operator, _claims) do
    {:ok, operator.id}
  end

  def subject_for_token(_, _) do
    {:error, :invalid_resource}
  end

  def resource_from_claims(claims) do
    Backoffice.one_operator_by_id(claims["sub"])
  end
end
