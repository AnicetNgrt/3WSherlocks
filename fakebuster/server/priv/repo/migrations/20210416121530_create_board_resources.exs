defmodule Fakebusters.Repo.Migrations.CreateBoardResources do
  use Ecto.Migration

  def change do
    create table(:board_resources) do
      add :defender_id, references(:users, on_delete: :nothing)
      add :board_id, references(:boards, on_delete: :nothing)
      add :resource_id, references(:topic_resources, on_delete: :nothing)

      timestamps()
    end

    create index(:board_resources, [:defender_id])
    create index(:board_resources, [:board_id])
    create index(:board_resources, [:resource_id])
  end
end
