defmodule DriverLocation.RedisClient do
  @redis_driver Application.get_env(:driver_location, :redis_driver)

  def add_location(driver_id, timestamp, value) do
    {:ok, json_value} = Jason.encode(value)

    case @redis_driver.zadd("drivers:#{driver_id}:locations", timestamp, json_value) do
      "1" -> {:ok, "1"}
      {:error, error} -> {:error, error}
    end
  end

  def locations(driver_id, start_time, end_time) do
    @redis_driver.zrangebyscore("drivers:#{driver_id}:locations", start_time, end_time)
    |> Enum.map(fn(json_location) ->
      {:ok, location} = Jason.decode(json_location)
      location
    end)
  end
end
