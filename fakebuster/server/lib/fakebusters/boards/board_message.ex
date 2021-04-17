defmodule Fakebusters.Boards.BoardMessage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "board_messages" do
    field :content, :string
    field :user_id, :id
    field :board_id, :id

    timestamps()
  end

  @doc false
  def changeset(board_message, attrs) do
    board_message
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
