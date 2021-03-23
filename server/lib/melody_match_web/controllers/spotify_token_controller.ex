defmodule MelodyMatchWeb.SpotifyTokenController do
  use MelodyMatchWeb, :controller

  alias MelodyMatch.Accounts
  alias MelodyMatch.Accounts.SpotifyToken

  action_fallback MelodyMatchWeb.FallbackController

  def create(conn, %{"spotify_token" => spotify_token_params}) do
    with {:ok, %SpotifyToken{} = spotify_token} <- Accounts.create_spotify_token(spotify_token_params) do
      conn
      |> put_status(:created)
      |> render("spotify_token.json", spotify_token: spotify_token)
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
