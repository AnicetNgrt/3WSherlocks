defmodule Fakebusters.Topics.TopicResource do
  use Ecto.Schema
  import Ecto.Changeset

  schema "topic_resources" do
    field :link, :string
    field :name, :string
    field :topic_id, :id

    timestamps()
  end

  @doc false
  def changeset(topic_resource, attrs) do
    topic_resource
    |> cast(attrs, [:name, :link])
    |> validate_required([:name, :link])
  end
end
