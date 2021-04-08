# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
use Mix.Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :melody_match, MelodyMatch.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

c_id =
  System.get_env("SPOTIFY_CLIENT_ID") ||
    raise """
    environment variable SPOTIFY_CLIENT_ID is missing.
    """

c_sec =
  System.get_env("SPOTIFY_CLIENT_SECRET") ||
  raise """
  environment variable SPOTIFY_CLIENT_SECRET is missing.
  """

red_uri = 
  System.get_env("SPOTIFY_REDIRECT_URI") ||
  raise """
  environment variable SPOTIFY_REDIRECT_URI is missing.
  """

config :melody_match, :spotify,
  client_id: c_id,
  client_secret: c_sec,
  redirect_uri: red_uri

config :melody_match, MelodyMatchWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :melody_match, MelodyMatchWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
