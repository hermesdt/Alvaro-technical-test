# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :gateway, GatewayWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QYQcac5SO5eFCxgmyY51oI059SsNIK70el59An7kZghgdBMqmL+ToNa4ejz7nU6k",
  render_errors: [view: GatewayWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Gateway.PubSub, adapter: Phoenix.PubSub.PG2]

config :gateway, Gateway.NsqProducer,
  nsqds: ["127.0.0.1:4150"]

config :gateway, Gateway.ZombieClient,
  http_driver: :httpc,
  zombie_service: [
    host: {:system, :string, "ZOMBIE_SERVICE_HOST", "localhost"},
    port: {:system, :integer, "ZOMBIE_SERVICE_PORT", "4001"}
  ]


# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
