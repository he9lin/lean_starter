defmodule LeanStarter.ProjectController do
  use LeanStarter.Web, :controller

  alias LeanStarter.Project
  alias LeanStarter.SessionController

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.LoadResource
  plug Guardian.Plug.EnsureAuthenticated, on_failure: { SessionController, :unauthenticated_api }

  plug :set_current_user
  plug :find_project            when action in [:show, :update, :delete]
  plug :scrub_params, "project" when action in [:create, :update]

  def index(conn, _params) do
    projects = Repo.all(assoc(current_user(conn), :projects))
    render(conn, "index.json", projects: projects)
  end

  def create(conn, %{"project" => project_params}) do
    changeset = Project.changeset(
      %Project{}, project_params |> Dict.put("user_id", current_user(conn).id)
    )

    case Repo.insert(changeset) do
      {:ok, project} ->
        conn
        |> put_status(:created)
        |> render("show.json", project: project)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(LeanStarter.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, _opts) do
    render(conn, "show.json", project: conn.assigns.project)
  end

  def update(conn, %{"project" => project_params}) do
    project = conn.assigns.project
    changeset = Project.changeset(project, project_params)

    case Repo.update(changeset) do
      {:ok, project} ->
        render(conn, "show.json", project: project)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(LeanStarter.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, _opts) do
    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(conn.assigns.project)
    send_resp(conn, :no_content, "")
  end

  defp set_current_user(conn, _opts) do
    assign(conn, :current_user, Guardian.Plug.current_resource(conn))
  end

  defp current_user(conn) do
    conn.assigns.current_user
  end

  defp find_project(conn, _opts) do
    project = Repo.get!(Project, conn.params["id"])
    assign(conn, :project, project)
  end
end

