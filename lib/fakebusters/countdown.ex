defmodule Fakebusters.Countdown do
  @moduledoc """
  Simple GenServer that can be spawned. Once spawned counts down for some duration and notifies a PubSub every second.
  """

  @step 1

  use GenServer

  @doc """
  Spawns a Countdown and subscribes the current process to its PubSub.
  """
  def spawn_and_subscribe(id, duration_sec) do
    Phoenix.PubSub.subscribe(Fakebusters.PubSub, "#{__MODULE__}#{id}")

    DynamicSupervisor.start_child(
      Fakebusters.CountdownsSupervisor,
      {__MODULE__, {id, duration_sec}}
    )
  end

  @doc false
  def start_link({id, duration_sec}) do
    name = String.to_atom("#{__MODULE__}#{id}")
    GenServer.start_link(__MODULE__, {id, duration_sec}, name: name)
  end

  @doc false
  @impl true
  def init(state) do
    schedule_countdown()

    {:ok, state}
  end

  @doc false
  @impl true
  def handle_info(:countdown, {id, duration_sec}) do
    duration_sec = duration_sec - @step

    Phoenix.PubSub.broadcast(
      Fakebusters.PubSub,
      "#{__MODULE__}#{id}",
      {__MODULE__, :countdown, duration_sec}
    )

    schedule_countdown()
    {:noreply, {id, duration_sec}}
  end

  defp schedule_countdown do
    Process.send_after(self(), :countdown, @step * 1000)
  end
end
