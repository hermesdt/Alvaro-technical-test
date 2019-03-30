defmodule Gateway.ZombieClient do
  use Confex, otp_app: :gateway
  @http_driver Application.get_env(:gateway, Gateway.ZombieClient)[:http_driver]

  def get(driver_id) do
    {:ok, response} = @http_driver.request(get_url(driver_id))
    {_status, _headers, body} = response
    body
  end

  def get_url(driver_id) do
    # '#{config()[:driver_locations_host]}/drivers/#{driver_id}'
    'http://#{host()}:#{port()}/drivers/#{driver_id}'
  end

  defp host(), do: config()[:zombie_service][:host]
  defp port(), do: config()[:zombie_service][:port]
end
