defmodule Fakebusters.Topics.Initiator do
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

  def start_link(_arg) do
    Task.start_link(__MODULE__, :run, [])
  end

  def run() do
    Enum.map(@topics, fn %{name: name} = topic ->
      case Repo.get_by(Topic, name: name) do
        %Topic{} = existingTopic ->
          Topics.update_topic(existingTopic, topic)

        nil ->
          Topics.create_topic(topic)
      end
    end)
  end
end
