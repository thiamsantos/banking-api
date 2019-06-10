# Since configuration is shared in umbrella projects, this file
# should only configure the :web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :web, Web.Endpoint,
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []
