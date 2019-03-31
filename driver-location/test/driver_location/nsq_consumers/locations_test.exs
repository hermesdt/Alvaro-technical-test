defmodule DriverLocation.NsqConsumers.LocationsTest do
  use ExUnit.Case, ascyn: true

  import Mox

  setup :verify_on_exit!

  test "has function topic with correct value" do
    assert DriverLocation.NsqConsumers.Locations.channel() == "driver_location"
  end

  test "has function channel with correct value" do
    assert DriverLocation.NsqConsumers.Locations.channel() == "driver_location"
  end

  test "#handle_message add messages into redis" do
    DriverLocation.RedisMock
    |> expect(:zadd, fn(_key, _score, _value) ->
      "1"
    end)

    message = %{"id" => 1, "latitude" => 2.02, "longitude" => 3.03}
    {:ok, json_message} = Jason.encode(message)

    DriverLocation.NsqConsumers.Locations.handle_message(json_message, %NSQ.Message{})
  end
end
