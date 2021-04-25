defmodule Fakebusters.Countdown do
  @moduledoc false

  @step 1

  use GenServer

  def spawn_and_subscribe(id, duration_sec) do
    Phoenix.PubSub.subscribe(Fakebusters.PubSub, "#{__MODULE__}#{id}")
    DynamicSupervisor.start_child(
      Fakebusters.CountdownsSupervisor,
      {__MODULE__, {id, duration_sec}}
    )
  end

  def start_link({id, duration_sec}) do
    IO.puts("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    IO.inspect(id)
    name = String.to_atom("#{__MODULE__}#{id}")
    IO.inspect(name)
    IO.puts("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    GenServer.start_link(__MODULE__, {id, duration_sec}, name: name)
  end

  @impl true
  def init(state) do
    schedule_countdown()

    {:ok, state}
  end

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
