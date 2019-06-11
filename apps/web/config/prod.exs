use Mix.Config

config :web, Web.Endpoint,
  http: [:inet6, port: System.get_env("PORT") || 4000],
  url: [host: System.get_env("HOST"), port: 443],
  server: true,
  cache_static_manifest: "priv/static/cache_manifest.json"
