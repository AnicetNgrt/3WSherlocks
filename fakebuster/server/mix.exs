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
      # Password hashing
      {:pbkdf2_elixir, "~> 1.0"},
      # Framework internals & DSL
      {:phoenix, "~> 1.5.7"},
      # Database
      {:phoenix_ecto, "~> 4.1"},
      # Database
      {:ecto_sql, "~> 3.4"},
      # Database
      {:postgrex, ">= 0.0.0"},
      # DOM patching through Websockets
      {:phoenix_live_view, "~> 0.15.0"},
      # HTML Parsing
      {:floki, ">= 0.27.0", only: :test},
      # Templating bits
      {:phoenix_html, "~> 2.11"},
      # Hot reload through LiveView
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      # Dashboard for admin monitoring
      {:phoenix_live_dashboard, "~> 0.4"},
      # Telemetry
      {:telemetry_metrics, "~> 0.4"},
      # Telemetry
      {:telemetry_poller, "~> 0.4"},
      # Strings externalization
      {:gettext, "~> 0.11"},
      # JSON encoding/decoding
      {:jason, "~> 1.0"},
      # API Middleware engine
      {:plug_cowboy, "~> 2.0"},

      # Fakebusters deps
      # Get user's on-site history
      {:navigation_history, "~> 0.4.0"},
      # Advanced Mathematical operations
      {:math, "~> 0.6.0"},
      # Emoji utility
      {:emojix, "~> 0.3.1"},

      # Dev deps
      # Auth system generator
      {:phx_gen_auth, "~> 0.7", only: [:dev], runtime: false},
      # Static code analysis
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      # Static code analysis
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false}
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
      lint: ["credo", "dialyzer"]
    ]
  end
end
