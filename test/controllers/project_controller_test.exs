defmodule LeanStarter.ProjectControllerTest do
  use LeanStarter.ConnCase, async: true

  alias LeanStarter.Project
  alias LeanStarter.User

  @valid_attrs %{description: "some content", name: "some content", slug: "some content"}
  @invalid_attrs %{name: ""}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    rand = LeanStarter.Randomise.random

    valid_registration_attrs = %{
      username: "superman#{rand}",
      email: "user#{rand}@example.com", password: "secretpwd"
    }
    changeset = User.registration_changeset(%User{}, valid_registration_attrs)
    {:ok, user} = Repo.insert changeset
    { :ok, jwt, _full_claims } = Guardian.encode_and_sign(user, :api)
    changeset = User.update_changeset(user, %{"auth_token" => jwt})
    { :ok, updated_user } = Repo.update changeset

    {:ok, conn: conn, user: updated_user}
  end

  test "returns 401 when not authenticated for index", %{conn: conn} do
    conn = get conn, project_path(conn, :index)
    assert json_response(conn, 401)
  end

  test "lists all entries on index", %{conn: conn, user: user} do
    conn = conn |> put_req_header("authorization", user.auth_token)
    conn = get conn, project_path(conn, :index)
    assert json_response(conn, 200)
  end

  test "shows chosen resource", %{conn: conn, user: user} do
    conn = conn |> put_req_header("authorization", user.auth_token)
    project = Repo.insert! %Project{name: "awesome project"}
    conn = get conn, project_path(conn, :show, project)
    assert json_response(conn, 200)["data"] == %{
      "id" => project.id,
      "user_id" => project.user_id,
      "name" => project.name,
      "slug" => project.slug,
      "description" => project.description
    }
  end

  test "throws error when not found", %{conn: conn, user: user} do
    conn = conn |> put_req_header("authorization", user.auth_token)
    assert_raise Ecto.NoResultsError, fn ->
      get conn, project_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, user: user} do
    conn = conn |> put_req_header("authorization", user.auth_token)
    conn = post conn, project_path(conn, :create), project: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert json_response(conn, 201)["data"]["user_id"] == user.id
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, user: user} do
    conn = conn |> put_req_header("authorization", user.auth_token)
    conn = post conn, project_path(conn, :create), project: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, user: user} do
    project = Repo.insert! %Project{name: "awesome project", user_id: user.id}
    conn = conn |> put_req_header("authorization", user.auth_token)
    conn = put conn, project_path(conn, :update, project), project: %{name: "awesome project"}
    assert json_response(conn, 200)["data"]["id"]
    assert "awesome project" = json_response(conn, 200)["data"]["name"]
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: user} do
    project = Repo.insert! %Project{name: "awesome project", user_id: user.id}
    conn = conn |> put_req_header("authorization", user.auth_token)
    conn = put conn, project_path(conn, :update, project), project: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, user: user} do
    project = Repo.insert! %Project{name: "awesome project", user_id: user.id}
    conn = conn |> put_req_header("authorization", user.auth_token)
    conn = delete conn, project_path(conn, :delete, project)
    assert response(conn, 204)
    refute Repo.get(Project, project.id)
  end
end
