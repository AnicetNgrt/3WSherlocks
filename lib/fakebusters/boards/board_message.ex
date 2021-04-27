defmodule Fakebusters.Boards.BoardMessage do
  @moduledoc false

  use Ecto.Schema
  alias Fakebusters.Boards.Channels
  import Ecto.Changeset

  schema "board_messages" do
    field :body, :string
    field :channel, :integer
    field :board_id, :id
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(board_message, attrs) do
    board_message
    |> cast(attrs, [:channel, :body, :user_id, :board_id])
    |> validate_required([:channel, :body, :user_id, :board_id])
    |> validate_inclusion(:channel, Channels.textable_channels_nums())
    |> validate_length(:body, min: 1, max: 1000)
  end
end
