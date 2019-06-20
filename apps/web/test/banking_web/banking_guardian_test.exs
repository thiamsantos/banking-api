defmodule Web.BankingGuardianTest do
  use Web.ConnCase, async: true

  alias Core.Repo
  alias Web.BankingGuardian

  describe "encode_and_sign/1" do
    test "valid account" do
      account = insert(:account)

      assert {:ok, token, claims} = BankingGuardian.encode_and_sign(account)

      assert %{"aud" => "banking", "iss" => "banking", "sub" => sub} = claims
      assert sub == account.id
    end

    test "invalid account" do
      assert BankingGuardian.encode_and_sign(nil) == {:error, :invalid_resource}
    end
  end

  describe "resource_from_token/1" do
    test "valid account" do
      account = insert(:account)

      assert {:ok, token, _claims} = BankingGuardian.encode_and_sign(account)
      {:ok, resource, _claims} = BankingGuardian.resource_from_token(token)

      assert resource.id == account.id
    end

    test "invalid account" do
      account = insert(:account)

      assert {:ok, token, _claims} = BankingGuardian.encode_and_sign(account)
      Repo.delete!(account)
      assert BankingGuardian.resource_from_token(token) == {:error, :not_found}
    end
  end
end
