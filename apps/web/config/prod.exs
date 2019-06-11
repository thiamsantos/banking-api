use Mix.Config

config :web, Web.Endpoint,
  server: true,
  cache_static_manifest: "priv/static/cache_manifest.json"
