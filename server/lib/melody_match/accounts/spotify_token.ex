defmodule MelodyMatch.Accounts.SpotifyToken do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:user_id, :id, []}
  @derive {Phoenix.Param, key: :user_id}
  schema "spotify_tokens" do
    field :auth_token, :string
    field :refresh_token, :string

    timestamps()
  end

  @doc false
  def changeset(spotify_token, attrs) do
    spotify_token
    |> cast(attrs, [:user_id, :auth_token, :refresh_token])
    |> validate_required([:auth_token, :refresh_token])
  end
end
