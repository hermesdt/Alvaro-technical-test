defmodule DriverLocationWeb.LocationsControllerTest do
  use DriverLocationWeb.ConnCase, async: false

  import Mox

  test "GET /drivers/:id/locations", %{conn: conn} do
    DriverLocation.RedisMock
    |> expect(:zrangebyscore, fn(_key, _min_score, _max_score) ->
      [
        "{\"driver_id\": 1, \"latitude\": 1, \"longitude\": 2}",
        "{\"driver_id\": 1, \"latitude\": 2, \"longitude\": 3}"
      ]
    end)

    message = conn
    |> get("/drivers/1/locations?minutes=5")
    |> json_response(200)

    assert message == [
      %{"driver_id" => 1, "latitude" => 1, "longitude" => 2},
      %{"driver_id" => 1, "latitude" => 2, "longitude" => 3}
    ]
  end

  test "GET /drivers/:id/locations returns error if query is missing", %{conn: conn} do
    message = conn
    |> get("/drivers/1/locations")
    |> json_response(400)

    assert message == %{"error" => "missing query parameters"}
  end

  describe "GET /drivers/:id/locations with different time ranges" do
    defmodule DateTimeMock do
      def now(), do: now("Etc/UTC")
      def now(_) do
        time = %{
          calendar: Calendar.ISO,
          day: 31,
          hour: 10,
          microsecond: {0, 0},
          minute: 10,
          month: 3,
          second: 0,
          std_offset: 0,
          time_zone: "Etc/UTC",
          utc_offset: 0,
          year: 2019,
          zone_abbr: "UTC"
        }

        {:ok, struct(DateTime, time)}
      end
    end

    setup do
      Application.put_env(:driver_location, :date_time, DateTimeMock)

      on_exit(fn() -> 
        Application.put_env(:driver_location, :date_time, DateTime)
      end)

      {:ok, now} = DateTimeMock.now()
      %{now: now}
    end

    test "minutes=5", %{conn: conn, now: now} do
      DriverLocation.RedisMock
      |> expect(:zrangebyscore, fn(_key, min_score, max_score) ->
        assert min_score == DateTime.to_unix(DateTime.add(now, -5 * 60, :second), :millisecond)
        assert max_score == DateTime.to_unix(now, :millisecond)
        []
      end)

      get(conn, "/drivers/1/locations?minutes=5")
    end

    test "hours=2", %{conn: conn, now: now} do
      DriverLocation.RedisMock
      |> expect(:zrangebyscore, fn(_key, min_score, max_score) ->
        assert min_score == DateTime.to_unix(DateTime.add(now, -2 * 60 * 60, :second), :millisecond)
        assert max_score == DateTime.to_unix(now, :millisecond)
        []
      end)

      get(conn, "/drivers/1/locations?hours=2")
    end

    test "seconds=90", %{conn: conn, now: now} do
      DriverLocation.RedisMock
      |> expect(:zrangebyscore, fn(_key, min_score, max_score) ->
        assert min_score == DateTime.to_unix(DateTime.add(now, -90, :second), :millisecond)
        assert max_score == DateTime.to_unix(now, :millisecond)
        []
      end)

      get(conn, "/drivers/1/locations?seconds=90")
    end
  end
end
