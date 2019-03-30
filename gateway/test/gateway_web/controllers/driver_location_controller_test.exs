defmodule Gateway.DriverLocationControllerTest do
  use GatewayWeb.ConnCase, async: true

  @tag :skip
  test "PATCH /drivers/:id/locations", %{conn: conn} do
    test_pid = self()
    {:ok, _consumer} = NSQ.Consumer.Supervisor.start_link("my-topic", "my-channel", %NSQ.Config{
      nsqds: Application.get_env(:gateway, Gateway.NsqProducer)[:nsqds],
      message_handler: fn(body, _msg) ->
        send(test_pid, {:nsq_message, body})
        :ok
      end
    })

    receive do
      {:nsq_message, body} -> :noop
    after
      400 -> raise "No message in 400 ms"
    end
  end
end
