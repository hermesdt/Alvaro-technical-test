defmodule DriveLocation.RedisClientTest do
  use ExUnit.Case, async: true

  import Mox

  alias DriverLocation.RedisClient

  setup :verify_on_exit!

  test "#add_location" do
    DriverLocation.RedisMock
    |> expect(:zadd, fn(_key, _score, _value) ->
      "1"
    end)

    value = %{"a" => "b"}
    
    assert RedisClient.add_location(1, 100, value) == {:ok, "1"}
  end

  test "#locations" do
    DriverLocation.RedisMock
    |> expect(:zrangebyscore, fn(_key, _min_score, _max_score) ->
      [
        "{\"driver_id\": 1, \"latitude\": 1, \"longitude\": 2}",
        "{\"driver_id\": 1, \"latitude\": 2, \"longitude\": 3}"
      ]
    end)
    
    assert RedisClient.locations(1, 100, 200) == [
      %{"driver_id" => 1, "latitude" => 1, "longitude" => 2},
      %{"driver_id" => 1, "latitude" => 2, "longitude" => 3}
    ]
  end
end
