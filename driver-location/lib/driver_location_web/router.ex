defmodule DriverLocationWeb.Router do
  use DriverLocationWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DriverLocationWeb do
    pipe_through :api

    get "/drivers/:id/locations", LocationsController, :index
  end
end
