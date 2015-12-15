defmodule LeanStarter.AuthenticatorTest do
  use LeanStarter.ModelCase, async: true

  alias LeanStarter.Authenticator
  alias LeanStarter.User

  test "login user by email" do
    valid_registration_attrs = %{
      username: "superman", email: "user@example.com", password: "secretpwd"
    }
    changeset = User.registration_changeset(%User{}, valid_registration_attrs)
    assert {:ok, user} = Repo.insert changeset

    valid_login_attrs = valid_registration_attrs |> Dict.delete(:username)
    {:ok, auth_user } = Authenticator.login(valid_login_attrs, Repo)
    assert auth_user.id == user.id
  end
end
