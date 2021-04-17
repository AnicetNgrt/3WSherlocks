defmodule Fakebusters.Repo.Migrations.CreateBoards do
  use Ecto.Migration

  def change do
    create table(:boards) do
      add :fact, :string
      add :description, :text
      add :rules, :text
      add :phase, :integer
      add :verdict_truthy, :integer
      add :verdict_falsy, :integer

      timestamps()
    end

    create index(:boards, [:phase])
  end
end
