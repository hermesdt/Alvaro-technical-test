defmodule DriverLocation.NsqConsumer do
  use Confex, otp_app: :driver_location

  defmacro __using__(_opts) do
    quote location: :keep do
      use GenServer

      import DriverLocation.NsqConsumer

      @name __MODULE__

      def start_link(_) do
        GenServer.start_link(@name, [], name: @name)
      end

      def init(_) do
        {:ok, consumer} = NSQ.Consumer.Supervisor.start_link(topic(), channel(), %NSQ.Config{
          nsqds: unquote(config())[:nsqds],
          message_handler: &@name.handle_message/2
        })

        {:ok, %{consumer: consumer}}
      end

      @before_compile DriverLocation.NsqConsumer
    end
  end

  defmacro __before_compile__(env) do
    quote do
      def topic, do: unquote(Module.get_attribute(env.module, :topic))
      def channel, do: unquote(Module.get_attribute(env.module, :channel))
    end
  end

  defmacro subscribe(topic, channel) do
    quote do
      @topic unquote(topic)
      @channel unquote(channel)
    end
  end
end
