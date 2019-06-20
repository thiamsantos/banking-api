defmodule Web.BackofficeGuardianTest do
  use Web.ConnCase, async: true

  alias Core.Repo
  alias Web.BackofficeGuardian

  describe "encode_and_sign/1" do
    test "valid operator" do
      operator = insert(:operator)

      assert {:ok, token, claims} = BackofficeGuardian.encode_and_sign(operator)

      assert %{"aud" => "backoffice", "iss" => "backoffice", "sub" => sub} = claims
      assert sub == operator.id
    end

    test "invalid operator" do
      assert BackofficeGuardian.encode_and_sign(nil) == {:error, :invalid_resource}
    end
  end

  describe "resource_from_token/1" do
    test "valid operator" do
      operator = insert(:operator)

      assert {:ok, token, _claims} = BackofficeGuardian.encode_and_sign(operator)
      {:ok, resource, _claims} = BackofficeGuardian.resource_from_token(token)

      assert resource.id == operator.id
    end

    test "invalid operator" do
      operator = insert(:operator)

      assert {:ok, token, _claims} = BackofficeGuardian.encode_and_sign(operator)
      Repo.delete!(operator)
      assert BackofficeGuardian.resource_from_token(token) == {:error, :not_found}
    end
  end
end
