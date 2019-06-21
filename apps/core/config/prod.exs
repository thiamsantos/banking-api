use Mix.Config

config :core, Core.Repo, log: false
config :core, Core.Mailer, adapter: Swoosh.Adapters.Sendgrid
