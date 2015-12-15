defmodule LeanStarter.SessionController do
  use LeanStarter.Web, :controller

  alias LeanStarter.User
  alias LeanStarter.Authenticator

  def create(conn, %{"email" => email, "password" => password}) do
    login_params = %{email: email, password: password}

    case Authenticator.login login_params, Repo do
      {:ok, user} ->
        { :ok, jwt, _full_claims } = Guardian.encode_and_sign(user, :api)
        changeset = User.update_changeset(user, %{"auth_token" => jwt})
        { :ok, updated_user } = Repo.update changeset

        conn
        |> put_status(:created)
        |> render(LeanStarter.UserView, "show.json", user: updated_user)
      {:error, reason} ->
        conn
        |> put_status(401)
        |> render(LeanStarter.ErrorView, "error.json", error: reason)
    end
  end
end

