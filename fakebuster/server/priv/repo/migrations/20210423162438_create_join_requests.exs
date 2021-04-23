defmodule Fakebusters.Repo.Migrations.CreateJoinRequests do
  use Ecto.Migration

  def change do
    create table(:join_requests) do
      add :motivation, :text
      add :preferred_role, :integer
      add :user_id, references(:users, on_delete: :nothing)
      add :board_id, references(:boards, on_delete: :nothing)

      timestamps()
    end

    create index(:join_requests, [:user_id])
    create index(:join_requests, [:board_id])
  end
end
