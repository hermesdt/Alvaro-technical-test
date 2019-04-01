defmodule ZombieDriver.DriverLocationsClient do
  use Confex, otp_app: :zombie_driver

  require Logger

  @http_driver Application.get_env(:zombie_driver, :http_driver)

  def get_locations(driver_id, unit, amount) do
    case @http_driver.request(:get, {get_url(driver_id, unit, amount), []}, [], []) do
      {:ok, {{_, 200, _}, _, json_locations}} ->
        Jason.decode(json_locations)

      {:ok, {{_, status, _}, _, body}} ->
        log(:error, ~s|unexpected answer from driver_location service
        status:#{status}, body:#{body}|)
        {:error, "unexpected answer from driver_location service"}

      {:error, error = {:failed_connect, _}} ->
        log(:error, "received error #{inspect(error)} when connecting to driver_location")
        {:error, "unable to connect to driver_location service"}
    end
  end

  def get_url(driver_id, unit, amount) do
    '#{config()[:driver_locations_host]}/drivers/#{driver_id}/locations?#{unit}=#{amount}'
  end

  defp log(:error, msg), do: Logger.error("#{__MODULE__}: #{msg}")
end
