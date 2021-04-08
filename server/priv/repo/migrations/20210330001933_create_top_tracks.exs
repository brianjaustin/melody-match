defmodule MelodyMatch.Repo.Migrations.CreateTopTracks do
  use Ecto.Migration

  def change do
    create table(:top_tracks) do
      add :track_id, :string, null: false
      add :danceability, :float, default: 0.0, null: false
      add :energy, :float, default: 0.0, null: false
      add :loudness, :float, default: 0.0, null: false
      add :mode, :float, default: 0.0, null: false
      add :speechiness, :float, default: 0.0, null: false
      add :acousticness, :float, default: 0.0, null: false
      add :instrumentalness, :float, default: 0.0, null: false
      add :liveness, :float, default: 0.0, null: false
      add :valence, :float, default: 0.0, null: false
      add :tempo, :float, default: 0.0, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:top_tracks, [:user_id])
  end
end
