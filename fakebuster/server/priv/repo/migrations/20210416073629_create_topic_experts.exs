defmodule Fakebusters.Repo.Migrations.CreateTopicExperts do
  use Ecto.Migration

  def change do
    create table(:topic_experts) do
      add :grade, :integer
      add :description, :text
      add :user_id, references(:users, on_delete: :nothing)
      add :topic_id, references(:topics, on_delete: :nothing)

      timestamps()
    end

    create index(:topic_experts, [:user_id])
    create index(:topic_experts, [:topic_id])
  end
end
