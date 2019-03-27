# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :driver_location, DriverLocationWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "qnuaQBjRP6mAPeQqnVvF9Ag3e+abFRG4pGk114eWdLnM9j4BjjExh9aQG/BI4qTv",
  render_errors: [view: DriverLocationWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: DriverLocation.PubSub, adapter: Phoenix.PubSub.PG2]

config :driver_location, DriverLocation.NsqConsumer,
  nsqds: {:system, :list, "NSQD_HOSTS", ["127.0.0.1:4150"]}

config :exredis, url: {:system, "REDIS_URL"}, max_queue: :infinity

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
