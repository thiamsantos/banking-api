use Mix.Config

config :web, Web.Endpoint,
  http: [:inet6, port: "${PORT}"],
  secret_key_base: "${SECRET_KEY_BASE}",
  url: [host: "${HOST}", port: 443],
  server: true,
  cache_static_manifest: "priv/static/cache_manifest.json"
