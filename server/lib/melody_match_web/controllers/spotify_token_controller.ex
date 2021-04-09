defmodule MelodyMatchWeb.SpotifyTokenController do
  use MelodyMatchWeb, :controller

  alias MelodyMatch.Accounts
  alias MelodyMatch.Accounts.SpotifyToken
  alias Spotify


  action_fallback MelodyMatchWeb.FallbackController

  plug :require_owner when action in [:update, :delete]

  def require_owner(conn, _params) do
    IO.inspect conn.params
    user_id = String.to_integer(conn.params["id"])
    user = Accounts.get_user!(user_id)

    current_user = conn.assigns[:current_user]


    if current_user && current_user.id == user.id do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> put_view(MelodyMatchWeb.ErrorView)
      |> render("unauthorized.json")
      |> halt()
    end
  end

  def create(conn, %{"id" => id, "auth_code" => auth_code}) do
    with {:ok, %SpotifyToken{} = spotify_token} <- Spotify.get_and_save_tokens(id, :code, auth_code) do
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
