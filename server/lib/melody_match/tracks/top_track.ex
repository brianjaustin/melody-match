defmodule MelodyMatch.Tracks.TopTrack do
  use Ecto.Schema
  import Ecto.Changeset

  alias MelodyMatch.Accounts.User

  schema "top_tracks" do
    field :acousticness, :float
    field :danceability, :float
    field :energy, :float
    field :instrumentalness, :float
    field :liveness, :float
    field :loudness, :float
    field :mode, :float
    field :speechiness, :float
    field :tempo, :float
    field :track_id, :string
    field :valence, :float
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(top_track, attrs) do
    top_track
    |> cast(attrs, [:track_id, :danceability, :energy, :loudness, :mode, :speechiness, :acousticness, :instrumentalness, :liveness, :valence, :tempo, :user_id])
    |> validate_required([:track_id, :user_id])
  end
end
