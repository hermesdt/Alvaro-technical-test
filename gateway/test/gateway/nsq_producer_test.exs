defmodule Gateway.NsqProducerTest do
  use ExUnit.Case, async: true

  describe "#publish" do
    test "when calling publish a message is received in nsq" do
      test_pid = self()
      {:ok, _consumer} = NSQ.Consumer.Supervisor.start_link("test.my-topic", "my-channel", %NSQ.Config{
        nsqds: Application.get_env(:gateway, Gateway.NsqProducer)[:nsqds],
        message_handler: fn(body, _msg) ->
          send(test_pid, {:nsq_message, body})
          :ok
        end
      })

      payload = "asdf"
      Gateway.NsqProducer.publish("my-topic", payload)

      assert_receive {:nsq_message, ^payload}
    end
  end
end
