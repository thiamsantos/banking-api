# Since configuration is shared in umbrella projects, this file
# should only configure the :web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :web,
  ecto_repos: [Core.Repo],
  generators: [context_app: :core, binary_id: true]

# Configures the endpoint
config :web, Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "uLxq5PLWNR2gYVy/dGkjM17vxFzfNBSBrjSLoAS2j/B479OhBMlr33P6+Py0iArZ",
  render_errors: [view: Web.ErrorView, accepts: ~w(json)],
  pubsub: [name: Web.PubSub, adapter: Phoenix.PubSub.PG2]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
