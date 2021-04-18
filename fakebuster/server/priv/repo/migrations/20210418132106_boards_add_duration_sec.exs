defmodule Fakebusters.Repo.Migrations.BoardsAddDurationSec do
  use Ecto.Migration

  def change do
    alter table(:boards) do
      add :duration_sec, :integer
    end
  end
end
