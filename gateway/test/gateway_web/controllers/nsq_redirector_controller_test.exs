defmodule Gateway.NsqRedirectorControllerTest do
  use GatewayWeb.ConnCase, async: true

  test "PATCH /drivers/:id/locations", %{conn: conn} do
    test_pid = self()
    {:ok, _consumer} = NSQ.Consumer.Supervisor.start_link("test.locations", "channel", %NSQ.Config{
      nsqds: Application.get_env(:gateway, Gateway.NsqProducer)[:nsqds],
      message_handler: fn(body, _msg) ->
        {:ok, payload} = Jason.decode(body)
        send(test_pid, {:nsq_message, payload})
        :ok
      end
    })

    message = %{"a" => "b"}

    conn
    |> patch("/drivers/1/locations", message)

    expected_message = Map.put(message, "id", "1")
    assert_receive {:nsq_message, ^expected_message}
  end
end
