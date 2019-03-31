defmodule DriverLocationWeb.LocationsController do
  use DriverLocationWeb, :controller

  alias DriverLocation.RedisClient

  def index(conn, %{"id" => driver_id, "hours" => n}) do
    _index(conn, driver_id, String.to_integer(n) * 3600, :seconds)
  end
  def index(conn, %{"id" => driver_id, "minutes" => n}) do
    _index(conn, driver_id, String.to_integer(n) * 60, :seconds)
  end
  def index(conn, %{"id" => driver_id, "seconds" => n}) do
    _index(conn, driver_id, String.to_integer(n), :seconds)
  end

  def index(conn, _params) do
    conn
    |> put_status(400)
    |> json(%{"error" => "missing query parameters"})
  end

  def _index(conn, driver_id, seconds, :seconds) do
    {:ok, end_time} = now()
    start_time = DateTime.add(end_time, -seconds, :second)

    start_time = DateTime.to_unix(start_time, :millisecond)
    end_time = DateTime.to_unix(end_time, :millisecond)

    locations = RedisClient.locations(driver_id, start_time, end_time)

    conn
    |> json(locations)
  end

  defp now() do
    Application.get_env(:driver_location, :date_time).now("Etc/UTC")
  end
end
