defmodule Gateway.NsqProducerTest do
  use ExUnit.Case, async: true

  describe "#publish" do
    test "when calling publish a message is received in nsq" do
      test_pid = self()
      {:ok, _consumer} = NSQ.Consumer.Supervisor.start_link("my-topic", "my-channel", %NSQ.Config{
        nsqds: Application.get_env(:gateway, Gateway.NsqProducer)[:nsqds],
        message_handler: fn(body, _msg) ->
          send(test_pid, {:nsq_message, body})
          :ok
        end
      })

      payload = "asdf"
      Gateway.NsqProducer.publish("my-topic", payload)
      receive do
        {:nsq_message, body} -> assert body == payload
      after
        400 -> raise "No message in 400 ms"
      end
    end
  end
end
