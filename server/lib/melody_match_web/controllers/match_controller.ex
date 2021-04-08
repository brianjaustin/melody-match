defmodule MelodyMatchWeb.MatchController do
  use MelodyMatchWeb, :controller

  alias MelodyMatch.Matches
  alias MelodyMatch.Matches.Match


  def show(conn, %{"id" => id}) do
    m = Matches.get_match!(id)
    render(conn, "show.json", match: m)
  end
end
