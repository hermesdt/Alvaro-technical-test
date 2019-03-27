defmodule ZombieDriver.DriverLocationsClient do
  use Confex, otp_app: :zombie_driver

  def get_locations(driver_id, unit, amount) do
    {:ok, response} = :httpc.request(get_url(driver_id, unit, amount))
    {_status, _headers, json_locations} = response
    {:ok, locations} = json_locations |> Jason.decode

    locations
  end

  def get_url(driver_id, unit, amount) do
    '#{config()[:driver_locations_host]}/drivers/#{driver_id}/locations?#{unit}=#{amount}'
  end
end