defmodule Fakebusters.Boards.BoardMember do
  @moduledoc false

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
    |> validate_inclusion(:role, [0, 1, 2, 3, 4])
    |> validate_required([:role, :user_id, :board_id])
    |> unsafe_validate_unique([:user_id, :board_id], Fakebusters.Repo)
  end

  def role_to_atom(0), do: :judge
  def role_to_atom(1), do: :truthy_advocate
  def role_to_atom(2), do: :false_advocate
  def role_to_atom(3), do: :truthy_defender
  def role_to_atom(4), do: :false_defender
  def role_to_atom(_), do: nil

  def role_human_readable(role) do
    case role do
      0 -> "judge"
      1 -> "truthy side's advocate"
      2 -> "false side's advocate"
      3 -> "truthy side's defender"
      4 -> "false side's defender"
      nil -> "outsider"
    end
  end
end
