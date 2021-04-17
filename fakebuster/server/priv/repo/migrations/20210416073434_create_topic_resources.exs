defmodule Fakebusters.Repo.Migrations.CreateTopicResources do
  use Ecto.Migration

  def change do
    create table(:topic_resources) do
      add :name, :string
      add :link, :string
      add :topic_id, references(:topics, on_delete: :nothing)

      timestamps()
    end

    create index(:topic_resources, [:topic_id])
  end
end
