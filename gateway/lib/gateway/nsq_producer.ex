defmodule Gateway.NsqProducer do
  use GenServer
  use Confex, otp_app: :gateway

  @name __MODULE__

  def start_link(default_topic) do
    GenServer.start_link(@name, default_topic, name: @name)
  end

  def init(default_topic) do
    {:ok, producer} = NSQ.Producer.Supervisor.start_link(default_topic, %NSQ.Config{
      nsqds: config()[:nsqds]
    })

    {:ok, %{producer: producer}}
  end

  def publish(topic, message) do
    GenServer.cast(@name, {:publish, topic, message})
  end

  def handle_cast({:publish, topic, message}, %{producer: producer}) do
    {:ok, "OK"} = NSQ.Producer.pub(producer, topic(topic), message)
    {:noreply, %{producer: producer}}
  end

  defp topic(topic) do
    config()[:topic_prefix] <> topic
  end
end
