use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :driver_location, DriverLocationWeb.Endpoint,
  http: [port: 4002],
  server: false

config :driver_location,
  redis_driver: DriverLocation.RedisMock

config :driver_location, DriverLocation.NsqConsumer,
  nsqds: {:system, :list, "NSQD_HOSTS", ["127.0.0.1:4150"]},
  topic_prefix: "test."

# Print only warnings and errors during test
config :logger, level: :warn
