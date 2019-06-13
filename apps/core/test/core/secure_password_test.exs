defmodule Core.SecurePasswordTest do
  use Core.DataCase, async: true

  alias Core.SecurePassword

  describe "digest/1" do
    test "generates a hash with 60 chars" do
      assert String.length(SecurePassword.digest("password")) == 60
    end
  end

  describe "valid?/2" do
    test "returns true for a valid hash" do
      hash = SecurePassword.digest("password")

      assert SecurePassword.valid?("password", hash) == true
    end

    test "returns false for a invalid hash" do
    hash = SecurePassword.digest("password")

      assert SecurePassword.valid?("other_password", hash) == false
    end
  end
end
