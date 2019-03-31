defmodule DriverLocation.RedisBehaviour do
  @callback zadd(String.t, integer, String.t) :: {:ok, integer} | {:error, term}
  @callback zrangebyscore(String.t, integer, integer) :: [String.t]
end
