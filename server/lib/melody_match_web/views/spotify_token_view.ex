defmodule MelodyMatchWeb.SpotifyTokenView do
  use MelodyMatchWeb, :view

  def render("spotify_token.json", %{spotify_token: spotify_token}) do
    %{success: spotify_token != nil}
  end
end
