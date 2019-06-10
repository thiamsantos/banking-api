# Since configuration is shared in umbrella projects, this file
# should only configure the :core application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :core, Core.Repo,
  username: "postgres",
  password: "postgres",
  database: "banking_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
