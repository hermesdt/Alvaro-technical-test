defmodule GatewayWeb.DriverLocationController do
  use GatewayWeb, :controller

  def create(conn, %{"id" => id, "latitude" => latitude, "longitude" => longitude}) do
    {:ok, message} = Jason.encode(%{
      driver_id: id, latitude: latitude, longitude: longitude
    })
    Gateway.NsqProducer.publish("locations", message) |> IO.inspect(label: "gateway")
    send_resp(conn, 201, "")
  end
end