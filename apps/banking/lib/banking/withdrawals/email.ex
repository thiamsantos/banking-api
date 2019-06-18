defmodule Banking.Withdrawals.Email do
  import Swoosh.Email
  alias Core.Schemas.{Account, Transaction}

  def withdrawal_email(%Account{} = account, %Transaction{} = transaction) do
    new()
    |> from(origin_email())
    |> to(account.email)
    |> text_body("Successfully withdrawal with value of R$ #{transaction.amount}")
  end

  defp origin_email do
    :banking
    |> Application.fetch_env!(__MODULE__)
    |> Keyword.fetch!(:from)
  end
end
