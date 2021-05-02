defmodule Fakebusters.Topics.Topic do
  @moduledoc """
  Topics schema and validation rules.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "topics" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(topic, attrs) do
    topic
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
