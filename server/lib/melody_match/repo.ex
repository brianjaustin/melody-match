defmodule MelodyMatch.Repo do
  use Ecto.Repo,
    otp_app: :melody_match,
    adapter: Ecto.Adapters.Postgres
end
