defmodule GatewayWeb.HttpRedirectorControllerTest do
  use GatewayWeb.ConnCase, async: true

  import Mox

  setup :verify_on_exit!

  test "GET /drivers/:id returns the information from zombie service", %{conn: conn} do
    Gateway.HttpcMock
    |> expect(:request, fn(_url) ->
      json_message = %{"id" => 42, "zombie" => true} |> Jason.encode
      response = {"200", [], json_message}
      {:ok, response}
    end)

    message = conn
    |> get("/drivers/1")
    |> json_response(200)

    assert message == %{"id" => 42, "zombie" => true}
  end
end