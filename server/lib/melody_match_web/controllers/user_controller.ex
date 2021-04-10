defmodule MelodyMatchWeb.UserController do
  use MelodyMatchWeb, :controller
  alias MelodyMatch.Accounts
  alias MelodyMatch.Accounts.User
  alias MelodyMatch.Matches

  action_fallback MelodyMatchWeb.FallbackController

  plug MelodyMatchWeb.Plugs.RequireToken when action in [:proxy, :matches, :update, :delete]

  plug :require_owner when action in [:proxy, :matches, :update, :delete]

  def require_owner(conn, _params) do
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

  def proxy(conn, %{"id" => id}) do
    result = Spotify.get_spotify_data(id)
    with {:ok, result} <- Spotify.get_spotify_data(id, 10) do
      conn
        |> put_view(MelodyMatchWeb.SpotifyView)
        |> render("show.json", result: result)
    end

  end

  def create(conn, %{"name" => name, "email" => email, "password" => password}) do
    updated_params = %{name: name, email: email, password: password}
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

  def update(conn, %{"id" => id, "name" => name, "email" => email, "password" => password}) do
    user = Accounts.get_user!(id)
    if not blank?(password) do
      hashed = Argon2.add_hash(password)
      updated_params = %{name: name, email: email, password: password, password_hash: hashed.password_hash}
      with {:ok, %User{} = user} <- Accounts.update_password(user, updated_params) do
        with {:ok, %User{} = user} <- Accounts.update_user(user, updated_params) do
          render(conn, "show.json", user: user)
        end
      end
    else
      updated_params = %{name: name, email: email}
      with {:ok, %User{} = user} <- Accounts.update_user(user, updated_params) do
        render(conn, "show.json", user: user)
      end
    end
  end

  defp blank?(nil), do: true
  defp blank?(""), do: true
  defp blank?(_), do: false

  def update(conn, %{"id" => id, "last_latitude" => lat, "last_longitude" => long}) do
    user = Accounts.get_user!(id)
    updated_params = %{last_latitude: lat, last_longitude: long}
    with {:ok, %User{} = user} <- Accounts.update_password(user, updated_params) do
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
