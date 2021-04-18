defmodule Fakebusters.Boards.Board do
  use Ecto.Schema
  import Ecto.Changeset

  schema "boards" do
    field :description, :string
    field :fact, :string
    field :phase, :integer
    field :rules, :string
    field :duration_sec, :integer
    field :verdict_falsy, :integer
    field :verdict_truthy, :integer

    timestamps()
  end

  @doc false
  def changeset(board, attrs) do
    board
    |> cast(attrs, [:fact, :description, :rules, :duration_sec])
    |> validate_required([:fact, :description, :rules, :duration_sec])
    |> validate_length(:fact, min: 6, max: 128)
    |> validate_length(:description, max: 1000)
    |> validate_length(:rules, max: 1000)
    |> validate_number(:duration_sec, greater_than: 300, less_than: 21600 * 60)
  end
end
