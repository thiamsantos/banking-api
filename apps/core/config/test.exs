use Mix.Config

config :core, Core.Repo, pool: Ecto.Adapters.SQL.Sandbox

config :core, Core.SecurePassword, rounds: 1
