use Mix.Config

fetch_env! = fn key ->
  case System.get_env(key) do
    nil -> raise ArgumentError, "Could not fetch environment #{key} because configuration #{key} was not set"
    value -> value
  end
end

config :core, Core.Repo,
  url: fetch_env!.("DATABASE_URL"),
  pool_size: "POOL_SIZE" |> fetch_env!.() |> String.to_integer()

config :web, Web.Endpoint,
  http: [:inet6, port: fetch_env!.("PORT")],
  secret_key_base: fetch_env!.("SECRET_KEY_BASE"),
  url: [host: fetch_env!.("HOST"), port: 443, scheme: "https"],
  force_ssl: true

config :timber,
  api_key: fetch_env!.("TIMBER_API_KEY"),
  source_id: fetch_env!.("TIMBER_SOURCE_ID")

config :web, Web.BankingGuardian,
  ttl: {String.to_integer(fetch_env!.("BANKING_SESSION_TOKEN_TTL_IN_MINUTES")), :minutes},
  secret_key: fetch_env!.("BANKING_SESSION_TOKEN_SECRET")

config :web, Web.BackofficeGuardian,
  ttl: {String.to_integer(fetch_env!.("BACKOFFICE_SESSION_TOKEN_TTL_IN_MINUTES")), :minutes},
  secret_key: fetch_env!.("BACKOFFICE_SESSION_TOKEN_SECRET")

config :banking, Banking.Withdrawals.Email,
  from: fetch_env!.("BANKING_WITHDRAWAL_FROM_EMAIL")

config :core, Core.Mailer,
  api_key: fetch_env!.("SENDGRID_API_KEY")
