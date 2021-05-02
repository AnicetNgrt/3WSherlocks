defmodule Fakebusters.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Fakebusters.Repo,
      # Start the Telemetry supervisor
      FakebustersWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Fakebusters.PubSub},
      # Start the Endpoint (http/https)
      FakebustersWeb.Endpoint,
      # Starts a job that inserts default topics
      {Fakebusters.Topics.Initiator, []},
      # Starts a dynamic supervisor for live cooldowns
      {
        DynamicSupervisor,
        strategy: :one_for_one, name: Fakebusters.CountdownsSupervisor
      }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Fakebusters.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    FakebustersWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
