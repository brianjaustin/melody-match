defmodule MelodyMatchWeb.SpotifyTokenController do
  use MelodyMatchWeb, :controller

  alias MelodyMatch.Accounts
  alias MelodyMatch.Accounts.SpotifyToken
  alias Spotify


  action_fallback MelodyMatchWeb.FallbackController

  def create(conn, %{"id" => id, "auth_code" => auth_code}) do
    with {:ok, %SpotifyToken{} = spotify_token} <- Spotify.get_and_save_tokens(id, auth_code) do
      send_resp(conn, :no_content, "")
    end
  end

  def update(conn, %{"id" => id, "spotify_token" => spotify_token_params}) do
    spotify_token = Accounts.get_spotify_token!(id)

    with {:ok, %SpotifyToken{} = spotify_token} <- Accounts.update_spotify_token(spotify_token, spotify_token_params) do
      render(conn, "spotify_token.json", spotify_token: spotify_token)
    end
  end

  def delete(conn, %{"id" => id}) do
    spotify_token = Accounts.get_spotify_token!(id)

    with {:ok, %SpotifyToken{}} <- Accounts.delete_spotify_token(spotify_token) do
      send_resp(conn, :no_content, "")
    end
  end
end
