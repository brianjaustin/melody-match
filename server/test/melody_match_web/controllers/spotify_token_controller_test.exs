defmodule MelodyMatchWeb.SpotifyTokenControllerTest do
  use MelodyMatchWeb.ConnCase

  alias MelodyMatch.Accounts

  @create_attrs %{
    auth_token: "some auth_token",
    refresh_token: "some refresh_token"
  }
  @update_attrs %{
    auth_token: "some updated auth_token",
    refresh_token: "some updated refresh_token"
  }
  @invalid_attrs %{auth_token: nil, refresh_token: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(%{
      email: "some@example.com",
      name: "some name",
      password: "some password_hash"})
    user
  end

  def fixture(:spotify_token) do
    user = fixture(:user)
    {:ok, spotify_token} = @create_attrs
    |> Map.put(:user_id, user.id)
    |> Accounts.create_spotify_token()
    spotify_token
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create spotify_token" do
    setup [:create_user]
    test "returns 201 when valid", %{conn: conn, user: user} do
      attrs = @create_attrs
      |> Map.put(:user_id, user.id)
      conn = post(conn, Routes.spotify_token_path(conn, :create), spotify_token: attrs)
      assert json_response(conn, 201)["success"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: _user} do
      conn = post(conn, Routes.spotify_token_path(conn, :create), spotify_token: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update spotify_token" do
    setup [:create_spotify_token]

    test "returns 200 when data is valid", %{conn: conn, spotify_token: spotify_token} do
      conn = put(conn, Routes.spotify_token_path(conn, :update, spotify_token), spotify_token: @update_attrs)
      assert json_response(conn, 200)["success"]
    end

    test "renders errors when data is invalid", %{conn: conn, spotify_token: spotify_token} do
      conn = put(conn, Routes.spotify_token_path(conn, :update, spotify_token), spotify_token: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete spotify_token" do
    setup [:create_spotify_token]

    test "deletes chosen spotify_token", %{conn: conn, spotify_token: spotify_token} do
      conn = delete(conn, Routes.spotify_token_path(conn, :delete, spotify_token))
      assert response(conn, 204)
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    %{user: user}
  end

  defp create_spotify_token(_) do
    spotify_token = fixture(:spotify_token)
    %{spotify_token: spotify_token}
  end
end
