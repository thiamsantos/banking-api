defmodule Core.SecurePassword do
  @rounds :core |> Application.fetch_env!(Core.SecurePassword) |> Keyword.fetch!(:rounds)

  def digest(password) when is_binary(password) do
    password
    |> sha512()
    |> Bcrypt.hash_pwd_salt(log_rounds: @rounds)
  end

  def valid?(password, hash) when is_binary(password) do
    password
    |> sha512()
    |> Bcrypt.verify_pass(hash)
  end

  defp sha512(text), do: :crypto.hash(:sha512, text)
end
