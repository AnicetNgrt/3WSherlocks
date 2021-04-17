defmodule Fakebusters.Repo.Migrations.CreateBoardTopics do
  use Ecto.Migration

  def change do
    create table(:board_topics) do
      add :rank, :integer
      add :board_id, references(:boards, on_delete: :nothing)
      add :topic_id, references(:topics, on_delete: :nothing)

      timestamps()
    end

    create index(:board_topics, [:board_id])
    create index(:board_topics, [:topic_id])
  end
end
