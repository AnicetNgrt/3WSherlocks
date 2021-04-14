# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :fake_news_search_engine,
  ecto_repos: [FakeNewsSearchEngine.Repo]

# Configures the endpoint
config :fake_news_search_engine, FakeNewsSearchEngineWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "XUnjjxkGYnHS2jGjcbC8GN1emssE3Wth02dOJEaU6CTarQ+1Xovvb9eNu2umlE7P",
  render_errors: [view: FakeNewsSearchEngineWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: FakeNewsSearchEngine.PubSub,
  live_view: [signing_salt: "mX7qLlXP"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
