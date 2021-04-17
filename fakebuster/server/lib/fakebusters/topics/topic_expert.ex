defmodule Fakebusters.Topics.TopicExpert do
  use Ecto.Schema
  import Ecto.Changeset

  schema "topic_experts" do
    field :description, :string
    field :grade, :integer
    field :user_id, :id
    field :topic_id, :id

    timestamps()
  end

  @doc false
  def changeset(topic_expert, attrs) do
    topic_expert
    |> cast(attrs, [:grade, :description])
    |> validate_required([:grade, :description])
  end
end
