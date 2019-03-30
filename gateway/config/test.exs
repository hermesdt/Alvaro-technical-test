use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :gateway, GatewayWeb.Endpoint,
  http: [port: 4002],
  server: false


config :gateway, Gateway.ZombieClient,
  http_driver: Gateway.HttpcMock

# Print only warnings and errors during test
config :logger, level: :warn
