defmodule Fakebusters.Boards.JoinRequest do
  @moduledoc """
  Join request schema and validation rules.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "join_requests" do
    field :motivation, :string
    field :preferred_role, :integer
    field :user_id, :id
    field :board_id, :id

    timestamps()
  end

  @doc false
  def changeset(join_request, attrs) do
    join_request
    |> cast(attrs, [:motivation, :preferred_role, :board_id, :user_id])
    |> validate_required([:motivation, :preferred_role, :board_id, :user_id])
    |> validate_length(:motivation, min: 6, max: 1000)
  end
end
