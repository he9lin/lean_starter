defmodule LeanStarter.ProjectControllerTest do
  use LeanStarter.ConnCase

  alias LeanStarter.Project
  @valid_attrs %{description: "some content", name: "some content", slug: "some content"}
  @invalid_attrs %{name: ""}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, project_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
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

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, project_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, project_path(conn, :create), project: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Project, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, project_path(conn, :create), project: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    project = Repo.insert! %Project{name: "some content"}
    conn = put conn, project_path(conn, :update, project), project: %{name: "awesome project"}
    assert json_response(conn, 200)["data"]["id"]
    assert "awesome project" = json_response(conn, 200)["data"]["name"]
    assert Repo.get_by(Project, name: "awesome project")
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    project = Repo.insert! %Project{name: "awesome project"}
    conn = put conn, project_path(conn, :update, project), project: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    project = Repo.insert! %Project{name: "awesome project"}
    conn = delete conn, project_path(conn, :delete, project)
    assert response(conn, 204)
    refute Repo.get(Project, project.id)
  end
end
