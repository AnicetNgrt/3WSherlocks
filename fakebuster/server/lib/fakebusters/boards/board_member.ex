defmodule Fakebusters.Boards.BoardMember do
  use Ecto.Schema
  import Ecto.Changeset

  schema "board_members" do
    field :role, :integer
    field :board_id, :id
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(board_member, attrs) do
    board_member
    |> cast(attrs, [:role])
    |> validate_required([:role])
  end
end
