use Mix.Config

config :core, Core.Repo, log: false

config :sample, Core.Mailer, adapter: Swoosh.Adapters.Sendgrid
