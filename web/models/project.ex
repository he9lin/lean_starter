defmodule LeanStarter.Project do
  use LeanStarter.Web, :model

  schema "projects" do
    field :name, :string
    field :slug, :string
    field :description, :string
    belongs_to :user, LeanStarter.User

    timestamps
  end

  @required_fields ~w(name user_id)
  @optional_fields ~w(slug description)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:name, min: 3, max: 20)
    |> slugify_name()
    |> foreign_key_constraint(:user_id)
  end

  defp slugify_name(changeset) do
    if name = get_change(changeset, :name) do
      put_change(changeset, :slug, slugify(name))
    else
      changeset
    end
  end

  defp slugify(str) do
    str
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/, "-")
  end
end

