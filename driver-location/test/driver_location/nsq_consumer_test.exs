defmodule DriverLocation.NsqConsumerTest do
  use ExUnit.Case, async: true

  setup do
    Process.register(self(), :current_test)
    :ok
  end

  defmodule FakeNsqConsumer do
    use DriverLocation.NsqConsumer

    subscribe("nsq_consumer_test", "test")

    def handle_message(body, _msg) do
      send(:current_test, {:received, body})
      :ok
    end
  end

  test "" do
    {:ok, _} = FakeNsqConsumer.start_link([])

    {:ok, producer} = NSQ.Producer.Supervisor.start_link("default", %NSQ.Config{
      nsqds: nsqds()
    })

    message = %{"id" => 1, "latitude" => 1, "longitude" => 2}
    {:ok, json_message} = Jason.encode(message)
    NSQ.Producer.pub(producer, "test.nsq_consumer_test", json_message)

    assert_receive {:received, json_message}
  end

  defp nsqds() do
    {:ok, config} = Confex.fetch_env(:driver_location, DriverLocation.NsqConsumer)
    config[:nsqds]
  end
end
