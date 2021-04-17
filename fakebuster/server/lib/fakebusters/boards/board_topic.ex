defmodule Fakebusters.Boards.BoardTopic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "board_topics" do
    field :rank, :integer
    field :board_id, :id
    field :topic_id, :id

    timestamps()
  end

  @doc false
  def changeset(board_topic, attrs) do
    board_topic
    |> cast(attrs, [:rank])
    |> validate_required([:rank])
  end
end
