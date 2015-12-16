defmodule LeanStarter.ProjectTest do
  use LeanStarter.ModelCase

  alias LeanStarter.Project

  @valid_attrs %{user_id: "1", description: "some description", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Project.changeset(%Project{}, @valid_attrs)
    assert changeset.valid?
  end

  test "slug generate" do
    changeset = Project.changeset(%Project{}, @valid_attrs)
    assert changeset.changes[:slug]
  end

  test "changeset with invalid attributes" do
    changeset = Project.changeset(%Project{}, @invalid_attrs)
    refute changeset.valid?
  end
end
