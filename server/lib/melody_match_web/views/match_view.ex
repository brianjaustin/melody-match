defmodule MelodyMatchWeb.MatchView do
  use MelodyMatchWeb, :view
  alias MelodyMatchWeb.MatchView
  alias MelodyMatch.Accounts
  alias MelodyMatchWeb.UserView

  def render("index.json", %{matches: matches}) do
    %{data: render_many(matches, MatchView, "match.json")}
  end

  def render("show.json", %{match: m}) do
    %{data: render_one(m, MatchView, "match.json")}
  end

  def render("match.json", %{match: m}) do
    first_user = Accounts.get_user!(m.first_user_id)
    second_user = Accounts.get_user!(m.second_user_id)
    %{id: m.id,
      users: render_many([first_user, second_user], UserView, "user.json")
     }
  end
end
