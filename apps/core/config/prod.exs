use Mix.Config

config :core, Core.Repo,
  url: "${DATABASE_URL}"
  pool_size: "${POOL_SIZE}"
