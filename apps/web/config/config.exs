use Mix.Config

__ENV__.file()
|> Path.dirname()
|> Path.join("../../../config/dotenv.exs")
|> Path.expand()
|> Code.eval_file()

# General application configuration
config :web,
  ecto_repos: [Core.Repo],
  generators: [context_app: :core, binary_id: true]

# Configures the endpoint
config :web, Web.Endpoint,
  url: [host: "localhost", port: Dotenv.fetch_env!("PORT")],
  http: [port: Dotenv.fetch_env!("PORT")],
  secret_key_base: Dotenv.fetch_env!("SECRET_KEY_BASE"),
  render_errors: [view: Web.ErrorView, accepts: ~w(json)],
  pubsub: [name: Web.PubSub, adapter: Phoenix.PubSub.PG2],
  instrumenters: [Timber.Phoenix]

config :web, Web.BankingGuardian,
  issuer: "banking",
  ttl: {Dotenv.fetch_integer_env!("BANKING_SESSION_TOKEN_TTL_IN_MINUTES"), :minutes},
  secret_key: Dotenv.fetch_env!("BANKING_SESSION_TOKEN_SECRET")

config :web, Web.BackofficeGuardian,
  issuer: "backoffice",
  ttl: {Dotenv.fetch_integer_env!("BACKOFFICE_SESSION_TOKEN_TTL_IN_MINUTES"), :minutes},
  secret_key: Dotenv.fetch_env!("BACKOFFICE_SESSION_TOKEN_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
