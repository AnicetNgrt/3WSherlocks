defmodule Fakebusters.Repo.Migrations.CreateBoardMessages do
  use Ecto.Migration

  def change do
    create table(:board_messages) do
      add :channel, :integer
      add :body, :text
      add :board_id, references(:boards, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:board_messages, [:board_id])
    create index(:board_messages, [:user_id])
  end
end
