defmodule GatewayWeb.DriverController do
  use GatewayWeb, :controller
  
  def show(conn, %{"id" => driver_id}) do
    {:ok, body} = Gateway.ZombieClient.get(driver_id)

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, body)
  end
end
