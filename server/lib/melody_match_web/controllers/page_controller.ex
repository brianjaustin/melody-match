defmodule MelodyMatchWeb.PageController do
  use MelodyMatchWeb, :controller

  def index(conn, _params) do
    client_id = Application.get_env(:melody_match, :spotify)[:client_id]
    render(conn, "index.html", client_id: client_id)
  end
end
