use Mix.Config

fetch_env! = fn key ->
  case System.get_env(key) do
    nil -> raise ArgumentError, "Could not fetch environment #{key} because configuration #{key} was not set"
    value -> value
  end
end


config :core, Core.Repo,
  url: fetch_env!.("DATABASE_URL"),
  pool_size: "POOL_SIZE" |> fetch_env!.() |> String.to_integer()

config :web, Web.Endpoint,
  http: [:inet6, port: fetch_env!.("PORT")],
  secret_key_base: fetch_env!.("SECRET_KEY_BASE"),
  url: [host: fetch_env!.("HOST"), port: 443, scheme: "https"],
  force_ssl: true
