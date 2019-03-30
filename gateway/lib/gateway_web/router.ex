defmodule GatewayWeb.Router do
  use GatewayWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GatewayWeb do
    pipe_through :api

    {:ok, urls} = Gateway.ServiceConfig.read("config.yaml")

    urls
    |> Enum.each(fn
      url = %{"handler" => %{nsq: nsq}} ->
        match url["method"], url["path"], NsqRedirectorController, :publish, private: %{nsq: nsq}
      
      url = %{"handler" => %{http: http}} ->
        match url["method"], url["path"], HttpRedirectorController, :redirect, private: %{http: http}
    end)
  end
end
