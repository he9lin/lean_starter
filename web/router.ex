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

  scope "/", LeanStarter do
    pipe_through :browser # Use the default browser stack

  end

  scope "/api", LeanStarter do
    pipe_through :api

    resources "/projects", ProjectController, except: [:new, :edit]
  end
end

