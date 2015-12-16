defmodule LeanStarter.Authenticator do
  import Comeonin.Bcrypt, only: [checkpw: 2]

  alias LeanStarter.User

  def login(%{email: email, password: password}, repo) \
    when not is_nil(email) and not is_nil(password) do
      user = repo.get_by(User, email: String.downcase(email))
      case authenticate(user, password) do
        true -> {:ok, user}
        _    -> {:error, "password is not valid"}
      end
  end

  def login(_, _), do: {:error, "invalid params"}

  defp authenticate(user, password) when not is_nil(user) do
    checkpw(password, user.encrypted_password)
  end

  defp authenticate(_, _), do: false
end
