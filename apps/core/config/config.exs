# Since configuration is shared in umbrella projects, this file
# should only configure the :core application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :core,
  ecto_repos: [Core.Repo]

import_config "#{Mix.env()}.exs"
