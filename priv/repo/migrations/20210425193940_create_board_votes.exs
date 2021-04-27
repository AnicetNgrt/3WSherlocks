defmodule Fakebusters.Repo.Migrations.CreateBoardVotes do
  use Ecto.Migration

  def change do
    create table(:board_votes) do
      add :side, :integer
      add :value, :integer
      add :board_id, references(:boards, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:board_votes, [:board_id])
    create index(:board_votes, [:user_id])
  end
end
