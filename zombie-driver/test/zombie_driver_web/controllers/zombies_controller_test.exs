defmodule ZombieDriverWeb.ZombiesControllerTest do
  use ZombieDriverWeb.ConnCase, async: true
  
  import Mox

  test "GET /drivers/:id no zombie", %{conn: conn} do
    ZombieDriver.HttpcMock
    |> expect(:request, fn(:get, {_url, _headers}, [], []) ->

      {:ok, json_message} = locations() |> Jason.encode
      headers = [{"content-type", "application/json"}]
      response = {{"HTTP/1.1", 200, "OK"}, headers, json_message}
      {:ok, response}
    end)

    message = conn
    |> get("/drivers/1")
    |> json_response(200)

    assert message == %{"id" => 1, "zombie" => false}
  end

  test "GET /drivers/:id zombie", %{conn: conn} do
    ZombieDriver.HttpcMock
    |> expect(:request, fn(:get, {_url, _headers}, [], []) ->

      {:ok, json_message} = zombie_locations() |> Jason.encode
      headers = [{"content-type", "application/json"}]
      response = {{"HTTP/1.1", 200, "OK"}, headers, json_message}
      {:ok, response}
    end)

    message = conn
    |> get("/drivers/1")
    |> json_response(200)

    assert message == %{"id" => 1, "zombie" => true}
  end

  test "GET /drivers/:id returning error", %{conn: conn} do
    ZombieDriver.HttpcMock
    |> expect(:request, fn(:get, {_url, _headers}, [], []) ->

      {:ok, json_message} = zombie_locations() |> Jason.encode
      headers = [{"content-type", "application/json"}]
      response = {{"HTTP/1.1", 200, "OK"}, headers, json_message}
      {:ok, response}
    end)

    message = conn
    |> get("/drivers/1")
    |> json_response(200)

    assert message == %{"id" => 1, "zombie" => true}
  end

  defp locations() do
    [
      %{
        "latitude" => 1.0,
        "longitude" => 2.0,
        "updated_at" => "2019-03-27T18:49:16.710072Z"
      },
      %{
        "latitude" => 1.02,
        "longitude" => 2.02,
        "updated_at" => "2019-03-27T18:49:20.465083Z"
      },
      %{
        "latitude" => 1.03,
        "longitude" => 2.03,
        "updated_at" => "2019-03-27T18:49:24.103430Z"
      },
      %{
        "latitude" => 1.04,
        "longitude" => 2.04,
        "updated_at" => "2019-03-27T18:49:27.301294Z"
      },
      %{
        "latitude" => 1.05,
        "longitude" => 2.05,
        "updated_at" => "2019-03-27T18:50:18.722433Z"
      }
    ]
  end

  defp zombie_locations() do
    [
      %{
        "latitude" => 1.0003,
        "longitude" => 2.0003,
        "updated_at" => "2019-03-27T18:49:24.103430Z"
      },
      %{
        "latitude" => 1.0004,
        "longitude" => 2.0004,
        "updated_at" => "2019-03-27T18:49:27.301294Z"
      },
      %{
        "latitude" => 1.0005,
        "longitude" => 2.0005,
        "updated_at" => "2019-03-27T18:50:18.722433Z"
      }
    ]
  end
end
