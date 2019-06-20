defmodule Backoffice.Operators do
  alias Core.{Repo, SecurePassword}
  alias Core.Schemas.Operator

  def create(%{email: email, password: password}) do
    params = %{
      email: email,
      password: password
    }

    %Operator{}
    |> Operator.changeset(params)
    |> Repo.insert()
  end

  def one_by_id(operator_id) do
    case Repo.get(Operator, operator_id) do
      nil -> {:error, :not_found}
      %Operator{} = operator -> {:ok, operator}
    end
  end

  def validate_credentials(%{email: email, password: password}) do
    email
    |> one_by_email()
    |> validate_password(password)
  end

  defp one_by_email(email) do
    case Repo.get_by(Operator, email: email) do
      nil -> {:error, :not_found}
      %Operator{} = operator -> {:ok, operator}
    end
  end

  defp validate_password({:error, _reason}, _), do: {:error, :invalid_email_or_password}

  defp validate_password({:ok, %Operator{} = operator}, password) do
    if SecurePassword.valid?(password, operator.encrypted_password) do
      {:ok, operator}
    else
      {:error, :invalid_email_or_password}
    end
  end
end
