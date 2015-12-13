defmodule LeanStarter.Repo.Migrations.CreateProject do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :name, :string, null: false
      add :slug, :string
      add :description, :text
      add :user_id, references(:users)

      timestamps
    end
    create index(:projects, [:user_id])

  end
end
