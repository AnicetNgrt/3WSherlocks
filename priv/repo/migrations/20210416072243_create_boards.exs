defmodule Fakebusters.Repo.Migrations.CreateBoards do
  use Ecto.Migration

  def change do
    create table(:boards) do
      add :fact, :string
      add :description, :text
      add :rules, :text
      add :finished, :boolean

      timestamps()
    end

    create index(:boards, [:finished])
  end
end
