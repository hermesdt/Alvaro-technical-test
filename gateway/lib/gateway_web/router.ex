defmodule GatewayWeb.Router do
  use GatewayWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GatewayWeb do
    pipe_through :api

    patch "/drivers/:id/locations", DriverLocationController, :create
    get "/drivers/:id", DriverController, :show
  end
end
