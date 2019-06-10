# Since configuration is shared in umbrella projects, this file
# should only configure the :core application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

__ENV__.file()
|> Path.dirname()
|> Path.join("../../../config/dotenv.exs")
|> Path.expand()
|> Code.eval_file()

config :core,
  ecto_repos: [Core.Repo]

config :core, Core.Repo, url: Dotenv.fetch_env!("DATABASE_URL")

import_config "#{Mix.env()}.exs"
