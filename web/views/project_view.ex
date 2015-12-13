defmodule LeanStarter.ProjectView do
  use LeanStarter.Web, :view

  def render("index.json", %{projects: projects}) do
    %{data: render_many(projects, LeanStarter.ProjectView, "project.json")}
  end

  def render("show.json", %{project: project}) do
    %{data: render_one(project, LeanStarter.ProjectView, "project.json")}
  end

  def render("project.json", %{project: project}) do
    %{id: project.id,
      user_id: project.user_id,
      name: project.name,
      slug: project.slug,
      description: project.description}
  end
end
