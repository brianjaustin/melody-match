# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

c_id =
  System.get_env("REACT_APP_CLIENT_ID") ||
    raise """
    environment variable REACT_APP_CLIENT_ID is missing.
    """

c_sec =
  System.get_env("CLIENT_SECRET") ||
  raise """
  environment variable CLIENT_SECRET is missing.
  """

red_uri = 
  System.get_env("REDIRECT_URI") ||
  raise """
  environment variable REDIRECT_URI is missing.
  """

config :melody_match, :spotify,
  client_id: c_id,
  client_secret: c_sec,
  redirect_uri: red_uri,
  ecto_repos: [MelodyMatch.Repo]

# Configures the endpoint
config :melody_match, MelodyMatchWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "a8aAaSbhIhddX50A5XH3rDAB2nALKPHEkfeXvASZIYqF/9H/0O/dglLS7qrR++hB",
  render_errors: [view: MelodyMatchWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: MelodyMatch.PubSub,
  live_view: [signing_salt: "8nDMjU4n"]

# Configures Argon2 hashing library (see
# https://github.com/riverrun/comeonin/wiki/Choosing-the-password-hashing-library#argon2)
config :argon2_elixir, t_cost: 2, m_cost: 8

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
