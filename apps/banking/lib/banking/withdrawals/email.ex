defmodule Banking.Withdrawals.Email do
  import Swoosh.Email
  alias Core.Schemas.{Account, Transaction}

  def withdrawal_email(%Account{} = account, %Transaction{} = transaction) do
    new()
    |> from(origin_email())
    |> to(account.email)
    |> reply_to(origin_email())
    |> subject("Withdrawal created")
    |> text_body(
      "Successfully created withdrawal with value of #{format_money(transaction.amount)}"
    )
  end

  defp format_money(amount) do
    amount
    |> Money.new(:BRL)
    |> Money.to_string(separator: ".", delimeter: ",", symbol_space: true)
  end

  defp origin_email do
    :banking
    |> Application.fetch_env!(__MODULE__)
    |> Keyword.fetch!(:from)
  end
end
