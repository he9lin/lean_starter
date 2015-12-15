defmodule LeanStarter.Repo.Migrations.AddAuthTokenToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :auth_token, :text
    end
  end
end
