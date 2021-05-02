defmodule Fakebusters.Topics.Initiator do
  @moduledoc """
  Inserts de-facto topics to the database.

  You may wonder why I did a database table in the first place if this is not dynamic?

  ...

  (no answers)

  # TODO Make it static
  """

  use Task
  require Logger
  alias Fakebusters.Repo
  alias Fakebusters.Topics
  alias Fakebusters.Topics.Topic

  @topics [
    %{name: "politics"},
    %{name: "medical"},
    %{name: "geopolitics"},
    %{name: "history"},
    %{name: "economics"},
    %{name: "wealth"},
    %{name: "philosophy"},
    %{name: "computer science"},
    %{name: "engineering"},
    %{name: "nature"},
    %{name: "research"},
    %{name: "military"},
    %{name: "education"},
    %{name: "social science"},
    %{name: "wellbeing"},
    %{name: "sports"},
    %{name: "psychology"},
    %{name: "culture"},
    %{name: "languages"},
    %{name: "food"}
  ]

  @doc false
  def start_link(_arg) do
    Task.start_link(__MODULE__, :run, [])
  end

  @doc false
  def run() do
    Enum.map(@topics, fn %{name: name} = topic ->
      case Repo.get_by(Topic, name: name) do
        %Topic{} = existing_topic ->
          Topics.update_topic(existing_topic, topic)

        nil ->
          Topics.create_topic(topic)
      end
    end)
  end
end
