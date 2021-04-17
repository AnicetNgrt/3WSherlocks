defmodule Fakebusters.Boards.Board do
  use Ecto.Schema
  import Ecto.Changeset

  schema "boards" do
    field :description, :string
    field :fact, :string
    field :phase, :integer
    field :rules, :string
    field :verdict_falsy, :integer
    field :verdict_truthy, :integer

    timestamps()
  end

  @doc false
  def changeset(board, attrs) do
    board
    |> cast(attrs, [:fact, :description, :rules, :phase, :verdict_truthy, :verdict_falsy])
    |> validate_required([:fact, :description, :rules, :phase, :verdict_truthy, :verdict_falsy])
  end
end
