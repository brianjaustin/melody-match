defmodule MelodyMatchWeb.SpotifyView do
  use MelodyMatchWeb, :view

  def render("show.json", %{result: result}) do
    %{data: render_one(result, SpotifyView, "spotify.json")}
  end

  def render("spotify.json", %{result: result}) do
    result
  end
end
