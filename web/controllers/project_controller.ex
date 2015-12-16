defmodule LeanStarter.ProjectController do
  use LeanStarter.Web, :controller

  alias LeanStarter.Project
  alias LeanStarter.SessionController

  plug :find_project            when action in [:show, :update, :delete]
  plug :scrub_params, "project" when action in [:create, :update]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
          [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, user) do
    projects = Repo.all(user_projects(user))
    render(conn, "index.json", projects: projects)
  end

  def create(conn, %{"project" => project_params}, user) do
    changeset =
      user
      |> build(:projects)
      |> Project.changeset(project_params)

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

  def show(conn, _opts, _user) do
    render(conn, "show.json", project: conn.assigns.project)
  end

  def update(conn, %{"project" => project_params}, _user) do
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

  def delete(conn, _opts, _user) do
    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(conn.assigns.project)
    send_resp(conn, :no_content, "")
  end

  defp find_project(conn, _opts) do
    project = Repo.get!(
      user_projects(conn.assigns.current_user), conn.params["id"]
    )
    assign(conn, :project, project)
  end

  defp user_projects(user) do
    assoc(user, :projects)
  end
end

