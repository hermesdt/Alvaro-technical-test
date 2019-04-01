use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :gateway, GatewayWeb.Endpoint,
  http: [port: 4002],
  server: false

config :gateway, Gateway.NsqProducer,
  nsqds: ["127.0.0.1:4150"],
  topic_prefix: "test."

config :gateway, Gateway.HttpClient,
  http_driver: Gateway.HttpcMock

config :gateway,
  service_config: "test/config.yaml"

# Print only warnings and errors during test
config :logger, level: :warn
