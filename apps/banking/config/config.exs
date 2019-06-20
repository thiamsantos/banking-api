use Mix.Config

__ENV__.file()
|> Path.dirname()
|> Path.join("../../../config/dotenv.exs")
|> Path.expand()
|> Code.eval_file()

config :banking, Banking.Withdrawals.Email, from: Dotenv.fetch_env!("BANKING_WITHDRAWAL_FROM_EMAIL")
