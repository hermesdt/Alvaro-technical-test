defmodule DriverLocation.MixProject do
  use Mix.Project

  def project do
    [
      app: :driver_location,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {DriverLocation.Application, []},
      extra_applications: [
        :logger,
        :runtime_tools,
        :exredis,
        :confex
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.2"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:exredis, ">= 0.2.4"},
      {:confex, "~> 3.4.0"},
      {:elixir_nsq, "~> 1.1.0"},
      {:mix_test_watch, "~> 0.8", only: :dev, runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
      {:mox, "~> 0.5", only: :test},
    ]
  end
end
