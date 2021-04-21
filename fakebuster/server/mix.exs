defmodule Fakebusters.MixProject do
  use Mix.Project

  def project do
    [
      app: :fakebusters,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      dialyzer: [plt_add_deps: :transitive]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Fakebusters.Application, []},
      extra_applications: [:logger, :runtime_tools]
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
      # Phoenix deps
      {:pbkdf2_elixir, "~> 1.0"}, # Password hashing
      {:phoenix, "~> 1.5.7"}, # Framework internals & DSL
      {:phoenix_ecto, "~> 4.1"}, # Database
      {:ecto_sql, "~> 3.4"}, # Database
      {:postgrex, ">= 0.0.0"}, # Database
      {:phoenix_live_view, "~> 0.15.0"}, # DOM patching through Websockets
      {:floki, ">= 0.27.0", only: :test}, # HTML Parsing
      {:phoenix_html, "~> 2.11"}, # Templating bits
      {:phoenix_live_reload, "~> 1.2", only: :dev}, # Hot reload through LiveView
      {:phoenix_live_dashboard, "~> 0.4"}, # Dashboard for admin monitoring
      {:telemetry_metrics, "~> 0.4"}, # Telemetry
      {:telemetry_poller, "~> 0.4"}, # Telemetry
      {:gettext, "~> 0.11"}, # Strings externalization
      {:jason, "~> 1.0"}, # JSON encoding/decoding
      {:plug_cowboy, "~> 2.0"}, # API Middleware engine

      # Fakebusters deps
      {:navigation_history, "~> 0.4.0"}, # Get user's on-site history
      {:math, "~> 0.6.0"}, # Advanced Mathematical operations

      # Dev deps
      {:phx_gen_auth, "~> 0.7", only: [:dev], runtime: false}, # Auth system generator
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false}, # Static code analysis
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false} # Static code analysis
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "lint.setup": ["deps.compile", "dialyzer --plt"],
      "lint": ["credo", "dialyzer"]
    ]
  end
end
