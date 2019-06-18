use Mix.Config

__ENV__.file()
|> Path.dirname()
|> Path.join("../../../config/dotenv.exs")
|> Path.expand()
|> Code.eval_file()

config :banking, Banking.TokenIssuer,
  issuer: "banking",
  ttl: {String.to_integer(System.get_env("BANKING_SESSION_TOKEN_TTL_IN_MINUTES")), :minutes},
  secret_key: System.get_env("BANKING_SESSION_TOKEN_SECRET")

config :banking, Banking.Withdrawals.Email, from: System.get_env("BANKING_WITHDRAWAL_FROM_EMAIL")
