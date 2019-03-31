# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :zombie_driver, ZombieDriverWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "vOpgQvQxrqDIVAiwDXhchS7KL1n/KywFBA6W748T8exRuI9Z+tEhb7H84g/9O0BM",
  render_errors: [view: ZombieDriverWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: ZombieDriver.PubSub, adapter: Phoenix.PubSub.PG2]

config :zombie_driver, ZombieDriver.StatusChecker,
  units: {:system, :string, "ELAPSED_UNITS", "minutes"},
  amount: {:system, :integer, "ELAPSED_AMOUNT", 5},
  zombie_distance_meters: {:system, :integer, "ZOMBIE_DISTANCE_METERS", 500}

config :zombie_driver, ZombieDriver.DriverLocationsClient,
  driver_locations_host: {:system, :string, "DRIVER_LOCATIONS_HOST", "http://localhost:4001"}

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
