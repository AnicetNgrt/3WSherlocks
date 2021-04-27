defmodule Fakebusters.Accounts.UserFavoriteTopic do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "user_favorite_topics" do
    field :user_id, :id
    field :topic_id, :id

    timestamps()
  end

  @doc false
  def changeset(user_favorite_topic, attrs) do
    user_favorite_topic
    |> cast(attrs, [])
    |> validate_required([])
  end
end
