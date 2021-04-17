defmodule Fakebusters.Repo.Migrations.CreateUserFavoriteTopics do
  use Ecto.Migration

  def change do
    create table(:user_favorite_topics) do
      add :user_id, references(:users, on_delete: :nothing)
      add :topic_id, references(:topics, on_delete: :nothing)

      timestamps()
    end

    create index(:user_favorite_topics, [:user_id])
    create index(:user_favorite_topics, [:topic_id])
  end
end
