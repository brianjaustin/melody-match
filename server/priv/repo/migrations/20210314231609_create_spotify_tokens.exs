defmodule MelodyMatch.Repo.Migrations.CreateSpotifyTokens do
  use Ecto.Migration

  def change do
    create table(:spotify_tokens, primary_key: false) do
      add :auth_token, :string
      add :refresh_token, :string
      add :user_id, references(:users, on_delete: :delete_all),
        primary_key: true

      timestamps()
    end
  end
end
