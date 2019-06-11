use Mix.Config

config :core, Core.Repo, pool_size: System.get_env("POOL_SIZE")
