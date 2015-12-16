defmodule LeanStarter.TestHelpers do
  alias LeanStarter.Repo
  alias LeanStarter.User

  def create_user(attrs \\ %{}) do
    rand = Base.encode16(:crypto.rand_bytes(8))
    changes = Dict.merge(%{
      email: "user#{rand}@example.com",
      username: "user#{rand}",
      password: "secretpwd",
    }, attrs)

    %User{}
      |> User.registration_changeset(changes)
      |> Repo.insert!()
  end

  def create_registered_user(attrs \\ %{}) do
    user = create_user(attrs)

    { :ok, jwt, _full_claims } = Guardian.encode_and_sign(user, :api)

    changeset = User.update_changeset(user, %{"auth_token" => jwt})
    { :ok, updated_user } = Repo.update changeset

    updated_user
  end

  # def insert_project(user, attrs \\ %{}) do
  #   user
  #   |> Ecto.Model.build(:projects, attrs)
  #   |> Repo.insert!()
  # end
end
