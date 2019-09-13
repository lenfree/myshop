# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :myshop,
  ecto_repos: [Myshop.Repo]

# Configures the endpoint
config :myshop, MyshopWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "jJ0TRRnUPbXXgn+mZvTO0sYgoVFq4GfkDr0EstBP7KNiyDzpKmrlTDoGW5MbJ1NS",
  render_errors: [view: MyshopWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Myshop.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "V2wMO3jMLaZ6sySlFfCKJt51ztFqzicB"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Use leex for liveview
config :phoenix,
  template_engines: [leex: Phoenix.LiveView.Engine]

# config :plug_session_mnesia,
#  table: :session,
#  max_age: 86_400

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
