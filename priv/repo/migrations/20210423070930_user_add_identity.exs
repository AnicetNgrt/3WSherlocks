defmodule Fakebusters.Repo.Migrations.UserAddIdentity do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :username, :string, null: false
      add :emoji, :string
    end
  end
end
