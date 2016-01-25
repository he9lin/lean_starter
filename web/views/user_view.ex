defmodule LeanStarter.UserView do
  use LeanStarter.Web, :view
  use JaSerializer.PhoenixView

  def type, do: "users"

  attributes [:email, :auth_token]
end

