defmodule DriverLocation.RedisClient do
  import Exredis.Api, only: [zadd: 3, zrangebyscore: 3]

  def add_location(driver_id, timestamp, value) do
    {:ok, json_value} = Jason.encode(value)
    "1" = zadd("drivers:#{driver_id}:locations", timestamp, json_value)
  end

  def locations(driver_id, start_time, end_time) do
    zrangebyscore("drivers:#{driver_id}:locations", start_time, end_time)
    |> Enum.map(fn(json_location) ->
      {:ok, location} = Jason.decode(json_location)
      location
    end)
  end
end
