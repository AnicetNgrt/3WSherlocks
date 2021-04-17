defmodule Fakebusters.Boards.BoardResource do
  use Ecto.Schema
  import Ecto.Changeset

  schema "board_resources" do
    field :defender_id, :id
    field :board_id, :id
    field :resource_id, :id

    timestamps()
  end

  @doc false
  def changeset(board_resource, attrs) do
    board_resource
    |> cast(attrs, [])
    |> validate_required([])
  end
end
