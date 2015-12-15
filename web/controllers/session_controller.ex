defmodule LeanStarter.SessionController do
  use LeanStarter.Web, :controller

  alias LeanStarter.User
  alias LeanStarter.Authenticator

  def create(conn, %{"email" => email, "password" => password}) do
    login_params = %{email: email, password: password}

    case Authenticator.login login_params, LeanStarter.Repo do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render(LeanStarter.UserView, "show.json", user: user)
      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(LeanStarter.ErrorView, "error.json", error: reason)
    end
  end
end

