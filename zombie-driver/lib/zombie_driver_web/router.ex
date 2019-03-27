defmodule ZombieDriverWeb.Router do
  use ZombieDriverWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ZombieDriverWeb do
    pipe_through :api

    get "/drivers/:id", ZombiesController, :show
  end
end
