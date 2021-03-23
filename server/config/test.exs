use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :melody_match, MelodyMatch.Repo,
  username: "melody_match",
  password: "p@ssw0rd",
  database: "melody_match_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :melody_match, MelodyMatchWeb.Endpoint,
  http: [port: 4002],
  server: false

# Configures Argon2 hashing library (see
# https://github.com/riverrun/comeonin/wiki/Choosing-the-password-hashing-library#argon2)
config :argon2_elixir, t_cost: 1, m_cost: 8

# Print only warnings and errors during test
config :logger, level: :warn
