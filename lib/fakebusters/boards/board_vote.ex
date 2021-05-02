defmodule Fakebusters.Boards.BoardVote do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "board_votes" do
    field :side, :integer
    field :value, :integer
    field :board_id, :id
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(board_vote, attrs, voter_role) do
    board_vote
    |> cast(attrs, [:side, :board_id, :user_id])
    |> validate_required([:side, :board_id, :user_id])
    |> put_value(voter_role)
    |> validate_inclusion(:side, [0, 1])
    # having value == 0 will fail the changeset
    # that's on purpose to avoid outsiders voting somehow
    |> validate_inclusion(:value, [1, 3, 10])
  end

  def put_value(changeset, voter_role) do
    change(changeset, value: role_vote_value(voter_role))
  end

  defp role_vote_value(0), do: 10
  defp role_vote_value(role) when role <= 2, do: 3
  defp role_vote_value(role) when is_integer(role), do: 1
  defp role_vote_value(_), do: 0
end
