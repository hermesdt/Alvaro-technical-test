defmodule DriverLocation.NsqConsumers.Locations do
  use DriverLocation.NsqConsumer

  alias DriverLocation.RedisClient

  subscribe("locations", "driver_location")

  def handle_message(json_body, _msg = %NSQ.Message{}) do
    {:ok, body} = Jason.decode(json_body)
    %{"driver_id" => driver_id, "latitude" => latitude, "longitude" => longitude} = body

    {:ok, updated_at} = DateTime.now("Etc/UTC")
    location_info = %{
      "latitude" => latitude,
      "longitude" => longitude,
      "updated_at" => updated_at
    }
    timestamp = DateTime.to_unix(updated_at, :millisecond)

    RedisClient.add_location(driver_id, timestamp, location_info)
    :ok
  end
end