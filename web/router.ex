defmodule LeanStarter.Router do
  use LeanStarter.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authentication do
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
    plug Guardian.Plug.EnsureAuthenticated, handler: LeanStarter.SessionController
    plug :put_current_user
  end

  scope "/", LeanStarter do
    pipe_through :browser # Use the default browser stack
  end

  scope "/api", LeanStarter do
    pipe_through :api

    post "/sessions", SessionController, :create

    scope "/users" do
      pipe_through :authentication

      resources "/projects", ProjectController, except: [:new, :edit]
    end
  end
end

