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

  def unauthenticated(conn, _params) do
    the_conn = put_status(conn, 401)
    case Guardian.Plug.claims(conn) do
      { :error, :no_session } -> json(the_conn, %{ error: "Login required" })
      { :error, reason } -> json(the_conn, %{ error: reason })
      _ -> json(the_conn, %{ error: "Login required" })
    end
  end
end

