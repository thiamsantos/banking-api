defmodule Banking.Withdrawals.EmailTest do
  use Banking.DataCase, async: true

  alias Banking.Withdrawals.Email

  describe "withdrawal_email/2" do
    test "valid email" do
      account = build(:account)
      withdrawal = build(:withdrawal, from_account: account, amount: 1000)

      origin_email =
        :banking
        |> Application.fetch_env!(Email)
        |> Keyword.fetch!(:from)

      %Swoosh.Email{} = email = Email.withdrawal_email(account, withdrawal)

      assert email.from == {"", origin_email}
      assert email.to == [{"", account.email}]
      assert email.reply_to == {"", origin_email}
      assert email.subject == "Withdrawal created"
      assert email.text_body == "Successfully created withdrawal with value of R$ 10,00"
    end
  end
end
