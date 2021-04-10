defmodule MelodyMatchWeb.SpotifyView do
  use MelodyMatchWeb, :view
  alias MelodyMatchWeb.SpotifyView

  def render("show.json", %{result: result}) do
    %{data: render_one(result, SpotifyView, "spotify.json")}
  end

  def render("spotify.json", %{spotify: result}) do
    result
  end
end
