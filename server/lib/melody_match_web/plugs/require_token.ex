defmodule MelodyMatchWeb.Plugs.RequireToken do
  @moduledoc """
  Plug for extracting users from connections based on the provided
  authentication token, included in the `x-auth` header.
  ## Attribution
    The code in this module is based upon that demonstrated in lecture, see
    https://github.com/NatTuck/scratch-2021-01/blob/master/notes-4550/14-ajax/notes.md
  """
  
  import Plug.Conn

  alias MelodyMatch.Accounts

  def init(args), do: args

  def call(conn, _args) do
    token = Enum.at(get_req_header(conn, "x-auth"), 0)
    case Phoenix.Token.verify(conn, "user_id", token, max_age: 86400) do
      {:ok, user_id} ->
        assign(conn, :current_user, Accounts.get_user!(user_id))
      {:error, _err} ->
        conn
        |> put_status(:unauthorized)
        |> Phoenix.Controller.put_view(MelodyMatchWeb.ErrorView)
        |> Phoenix.Controller.render("unauthorized.json")
        |> halt()
    end
  end
end
