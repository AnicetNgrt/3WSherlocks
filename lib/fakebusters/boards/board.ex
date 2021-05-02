defmodule Fakebusters.Boards.Board do
  @moduledoc """
  Board schema and validation rules
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Fakebusters.Topics.Topic

  schema "boards" do
    field :description, :string
    field :fact, :string
    field :finished, :boolean, default: false
    field :rules, :string
    field :duration_sec, :integer
    belongs_to :topic, Topic

    timestamps()
  end

  @doc false
  def changeset(board, attrs) do
    board
    |> cast(attrs, [:fact, :description, :rules, :duration_sec, :topic_id, :finished])
    |> validate_required([:fact, :description, :rules, :duration_sec, :topic_id])
    |> validate_length(:fact, min: 6, max: 128)
    |> validate_length(:description, max: 1000)
    |> validate_length(:rules, max: 1000)
    |> validate_number(:duration_sec, greater_than: 300, less_than: 21_600 * 60)
  end
end
