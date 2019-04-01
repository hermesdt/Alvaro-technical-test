use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :zombie_driver, ZombieDriverWeb.Endpoint,
  http: [port: 4002],
  server: false

config :zombie_driver,
  http_driver: ZombieDriver.HttpcMock

# Print only warnings and errors during test
config :logger, level: :warn
