defmodule Fakebusters.Boards.BoardMember do
  use Ecto.Schema
  import Ecto.Changeset

  schema "board_members" do
    field :role, :integer
    field :user_id, :id
    field :board_id, :id

    timestamps()
  end

  @doc false
  def changeset(board_member, attrs) do
    board_member
    |> cast(attrs, [:role, :user_id, :board_id])
    |> validate_inclusion(:role, [0, 1, 2])
    |> validate_required([:role, :user_id, :board_id])
    |> unsafe_validate_unique([:user_id, :board_id], Fakebusters.Repo)
  end

  def role(:judge), do: 0

  def role(:truthy_advocate), do: 1

  def role(:falsy_advocate), do: 2
end
