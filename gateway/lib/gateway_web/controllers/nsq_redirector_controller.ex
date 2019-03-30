defmodule GatewayWeb.NsqRedirectorController do
  use GatewayWeb, :controller

  def publish(conn = %{private: %{nsq: %{"topic" => topic}}}, params) do
    {:ok, message} = Jason.encode(params)

    :ok = Gateway.NsqProducer.publish(topic, message)
    send_resp(conn, 200, "")
  end
end
