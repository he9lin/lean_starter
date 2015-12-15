defmodule LeanStarter.UserTest do
  use LeanStarter.ModelCase, async: true

  alias LeanStarter.User

  @valid_attrs %{email: "user@example.com", username: "someone"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "registration changeset" do
    valid_registration_attrs = \
      @valid_attrs |> Dict.put(:password, "somesecret")
    changeset = User.registration_changeset(%User{}, valid_registration_attrs)
    assert changeset.valid?
    assert {:ok, user} = Repo.insert changeset
    assert user.encrypted_password
  end
end

