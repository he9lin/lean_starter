defmodule LeanStarter.ProjectView do
  use LeanStarter.Web, :view
  use JaSerializer.PhoenixView

  def type, do: "projects"

  attributes [:user_id, :name, :slug, :description]
end
