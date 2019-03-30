defmodule GatewayWeb.DriverLocationController do
  use GatewayWeb, :controller

  def create(conn, %{"id" => id, "latitude" => latitude, "longitude" => longitude}) do
    {:ok, message} = Jason.encode(%{
      driver_id: id, latitude: latitude, longitude: longitude
    })
    :ok = Gateway.NsqProducer.publish("locations", message)
    send_resp(conn, 201, "")
  end
end
