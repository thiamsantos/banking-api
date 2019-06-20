defmodule Backoffice.Operators do
  alias Core.Repo
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
end
