# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :fakebusters,
  ecto_repos: [Fakebusters.Repo]

# Configures the endpoint
config :fakebusters, FakebustersWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5XeUFMf5Y8ObXia3Y9ABiyzcDfjf4Ytt9A9w9dpvzg4Osi9hXbBNGFw+FgQGc/XL",
  render_errors: [view: FakebustersWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Fakebusters.PubSub,
  live_view: [signing_salt: "8Q79qaCA"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  level: :info,
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
