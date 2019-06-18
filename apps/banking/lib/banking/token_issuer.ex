defmodule Banking.TokenIssuer do
  use Guardian, otp_app: :banking

  alias Banking.Accounts
  alias Core.Schemas.Account

  def subject_for_token(%Account{} = account, _claims) do
    {:ok, account.id}
  end

  def subject_for_token(_, _) do
    {:error, :invalid_resource}
  end

  def resource_from_claims(claims) do
    {:ok, Accounts.one_by_id(claims["sub"])}
  end
end
