defmodule LeanStarter.TestHelpers do
  alias LeanStarter.Repo

  def create_user(attrs \\ %{}) do
    changes = Dict.merge(%{
      name: "Some User",
      username: "user#{Base.encode16(:crypto.rand_bytes(8))}",
      password: "supersecret",
    }, attrs)

    %LeanStarter.User{}
    |> LeanStarter.User.registration_changeset(changes)
    |> Repo.insert!()
  end

  # def insert_project(user, attrs \\ %{}) do
  #   user
  #   |> Ecto.Model.build(:projects, attrs)
  #   |> Repo.insert!()
  # end
end
