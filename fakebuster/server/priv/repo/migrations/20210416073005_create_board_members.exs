defmodule Fakebusters.Repo.Migrations.CreateBoardMembers do
  use Ecto.Migration

  def change do
    create table(:board_members) do
      add :role, :integer
      add :board_id, references(:boards, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:board_members, [:board_id])
    create index(:board_members, [:user_id])
  end
end
