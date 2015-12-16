defmodule LeanStarter.Auth do
  import Plug.Conn

  def init(_opts) do
  end

  def put_current_user(conn, _opts) do
    conn |> assign(:current_user, Guardian.Plug.current_resource(conn))
  end
end
