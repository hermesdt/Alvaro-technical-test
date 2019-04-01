defmodule ZombieDriver.DriverLocationsClient do
  use Confex, otp_app: :zombie_driver

  @http_driver Application.get_env(:zombie_driver, :http_driver)

  def get_locations(driver_id, unit, amount) do
    case @http_driver.request(:get, {get_url(driver_id, unit, amount), []}, [], []) do
      {:ok, response} ->
        {{_http_version, 200, _reason}, _headers, json_locations} = response
        Jason.decode(json_locations)
      {:error, error} -> {:error, error}
    end
  end

  def get_url(driver_id, unit, amount) do
    '#{config()[:driver_locations_host]}/drivers/#{driver_id}/locations?#{unit}=#{amount}'
  end
end
