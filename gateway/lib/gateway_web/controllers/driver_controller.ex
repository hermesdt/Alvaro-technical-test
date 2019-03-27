defmodule GatewayWeb.DriverController do
  use GatewayWeb, :controller
  
  def show(conn, %{"id" => driver_id}) do
    {:ok, response} = :httpc.request(get_url(driver_id))
    {_status, _headers, body} = response

    send_resp(conn, 200, body)
  end

  def get_url(driver_id) do
    # '#{config()[:driver_locations_host]}/drivers/#{driver_id}'
    'http://localhost:4001/drivers/#{driver_id}'
  end
end