defmodule LeanStarter.SessionControllerTest do
  use LeanStarter.ConnCase, async: true

  alias LeanStarter.User

  setup do
    conn = conn() |> put_req_header("accept", "application/json")

    valid_registration_attrs = %{
      username: "superman1", email: "user1@example.com", password: "secretpwd"
    }
    user = %User{}
           |> User.registration_changeset(valid_registration_attrs)
           |> Repo.insert!

    {:ok, conn: conn, user: user}
  end

  test "login", %{conn: conn, user: user} do
    conn = \
      post conn, "/api/sessions", %{email: user.email, password: "secretpwd"}
    assert json_response(conn, 201)["data"]
    assert json_response(conn, 201)["data"]["auth_token"]
  end
end

