use Mix.Config

config :core, Core.Repo, pool_size: Dotenv.fetch_env!("POOL_SIZE")
