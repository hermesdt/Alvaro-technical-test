defmodule GatewayWeb.HttpRedirectorControllerTest do
  use GatewayWeb.ConnCase, async: true

  import Mox

  setup :verify_on_exit!

  test "GET /drivers/:id returns the information from zombie service", %{conn: conn} do
    Gateway.HttpcMock
    |> expect(:request, fn(:get, {_url, _headers}, [], []) ->
      {:ok, json_message} = %{"id" => 42, "zombie" => true} |> Jason.encode
      headers = [{"content-type", "application/json"}]
      response = {{"HTTP/1.1", 200, "OK"}, headers, json_message}
      {:ok, response}
    end)

    message = conn
    |> get("/drivers/1")
    |> json_response(200)

    assert message == %{"id" => 42, "zombie" => true}
  end

  test "GET /drivers/:id raises an internal error", %{conn: conn} do
    Gateway.HttpcMock
    |> expect(:request, fn(:get, {_url, _headers}, [], []) ->
      {:error, {:headers_error, :not_strings}}
    end)

    message = conn
    |> get("/drivers/1")
    |> text_response(500)

    assert message == "{:headers_error, :not_strings}"
  end

  test "POST /drivers returns the information from zombie service", %{conn: conn} do
    Gateway.HttpcMock
    |> expect(:request, fn(:post, {_url, _headers, _content_type, body}, [], []) ->
      {:ok, json_message} = body |> Jason.encode
      headers = [{"content-type", "application/json"}]
      response = {{"HTTP/1.1", 200, "OK"}, headers, json_message}
      {:ok, response}
    end)

    message = conn
    |> post("/drivers", %{"a" => "b"})
    |> json_response(200)

    assert message == %{"a" => "b"}
  end
end
