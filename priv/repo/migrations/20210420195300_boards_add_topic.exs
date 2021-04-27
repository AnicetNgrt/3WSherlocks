defmodule Fakebusters.Repo.Migrations.BoardsAddTopic do
  use Ecto.Migration

  def change do
    alter table(:boards) do
      add :topic_id, references(:topics)
    end
  end
end
