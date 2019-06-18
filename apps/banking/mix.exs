defmodule Banking.MixProject do
  use Mix.Project

  def project do
    [
      app: :banking,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:core, in_umbrella: true},
      {:faker, "~> 0.12.0", only: :test},
      {:guardian, "~> 1.2"},
      {:ecto, "~> 3.1"},
      {:swoosh, "~> 0.23.2"},
      {:money, "~> 1.4"}
    ]
  end
end
