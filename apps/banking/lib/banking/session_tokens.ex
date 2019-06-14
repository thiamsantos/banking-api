defmodule Banking.SessionTokens do
  alias Banking.{Accounts, TokenIssuer}
  alias Core.Schemas.Account
  alias Core.SecurePassword

  def create(%{email: email, password: password}) do
    email
    |> Accounts.one_by_email()
    |> validate_password(password)
    |> issue_token()
  end

  defp validate_password({:error, _reason}, _), do: {:error, :invalid_email_or_password}

  defp validate_password({:ok, %Account{} = account}, password) do
    if SecurePassword.valid?(password, account.encrypted_password) do
      {:ok, account}
    else
      {:error, :invalid_email_or_password}
    end
  end

  defp issue_token({:error, reason}), do: {:error, reason}

  defp issue_token({:ok, %Account{} = account}) do
    case TokenIssuer.encode_and_sign(account) do
      {:ok, token, _claims} -> {:ok, token}
      {:error, reason} -> {:error, reason}
    end
  end
end
