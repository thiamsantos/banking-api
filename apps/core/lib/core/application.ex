defmodule Core.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    :ok =
      :telemetry.attach(
        "timber-core-repo-query-handler",
        [:core, :repo, :query],
        &Timber.Ecto.handle_event/4,
        log_level: :info
      )

    :ok = Logger.add_translator({Timber.Exceptions.Translator, :translate})

    children = [
      Core.Repo
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Core.Supervisor)
  end
end
