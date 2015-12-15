# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :lean_starter, LeanStarter.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "MW6Fm3BseHCpMwAQXLR9a7xkpvF637qHFtmG34/t3DKQQgiQLq70M0ohFmWht8TZ",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: LeanStarter.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :joken, config_module: Guardian.JWT

config :guardian, Guardian,
  issuer: "LeanStarter",
  ttl: { 100_000, :days },
  verify_issuer: true,
  secret_key: "EPROIUELKJSDOIUEWORIJWLEKJFSODIojwoeirjsldkfjwoerijowkjflsef",
  serializer: LeanStarter.GuardianSerializer,
  hooks: LeanStarter.GuardianHooks,
  permissions: %{
    default: [:read_profile, :write_profile]
  }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false
