defmodule Banking.TokenIssuerTest do
  use Banking.DataCase, async: true

  alias Banking.TokenIssuer

  describe "encode_and_sign/1" do
    test "valid account" do
      account = insert(:account)

      assert {:ok, token, claims} = TokenIssuer.encode_and_sign(account)

      assert %{"aud" => "banking", "iss" => "banking", "sub" => sub} = claims
      assert sub == account.id
    end

    test "invalid account" do
      assert TokenIssuer.encode_and_sign(nil) == {:error, :invalid_resource}
    end
  end
end
