defmodule MelodyMatchWeb.UserController do
  use MelodyMatchWeb, :controller
  alias MelodyMatch.Accounts
  alias MelodyMatch.Accounts.User
  alias MelodyMatch.Matches

  action_fallback MelodyMatchWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def matches(conn, %{"id" => id}) do
    matches = Matches.get_matches_by_user_id(id)
    conn
    |> put_view(MelodyMatchWeb.MatchView)
    |> render("index.json", matches: matches)
  end

  def create(conn, %{"name" => name, "email" => email, "password" => password}) do
    hashed = Argon2.add_hash(password)
    updated_params = %{"name": name, "email": email, "password": password, "password_hash": hashed.password_hash}
    with {:ok, %User{} = user} <- Accounts.create_user(updated_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "name" => name, "email" => email, "password" => password, "location" => location}) do
    user = Accounts.get_user!(id)
    hashed = Argon2.add_hash(password)
    updated_params = %{"name": name, "email": email, "password": password, "password_hash": hashed.password_hash, "location": location}
    with {:ok, %User{} = user} <- Accounts.update_user(user, updated_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
