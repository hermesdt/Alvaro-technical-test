defmodule DriveLocation.RedisClientTest do
  use ExUnit.Case, async: true

  # import Mox
  
  # alias DriverLocation.Mocks.RedisMock
  alias DriverLocation.RedisClient

  # setup :verify_on_exit!

  test "add_location" do
    value = %{"a" => "b"}
    

    assert RedisClient.add_location(1, 100, value) == "1"
  end
end
