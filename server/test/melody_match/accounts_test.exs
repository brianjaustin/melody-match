defmodule MelodyMatch.AccountsTest do
  use MelodyMatch.DataCase

  alias MelodyMatch.Accounts

  describe "users" do
    alias MelodyMatch.Accounts.User

    @valid_attrs %{email: "some@example.com", name: "some name", password: "super_strong_pass1234"}
    @update_attrs %{email: "t2@example.com", name: "some updated name"}
    @invalid_attrs %{email: nil, name: nil, password_hash: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some@example.com"
      assert user.name == "some name"
      assert user.password_hash != nil
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "t2@example.com"
      assert user.name == "some updated name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "update_password/2 with valid password changes password hash" do
      user = user_fixture()
      assert {:ok, %User{} = result} = Accounts.update_password(user, %{password: "super_stron_p@ssw0rd"})
      assert result.password_hash
      assert user.password_hash != result.password_hash
    end

    test "update_password/2 with invalid password returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_password(user, %{password: "bad"})
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "spotify_tokens" do
    alias MelodyMatch.Accounts.SpotifyToken

    @valid_attrs %{auth_token: "some auth_token", refresh_token: "some refresh_token"}
    @update_attrs %{auth_token: "some updated auth_token", refresh_token: "some updated refresh_token"}
    @invalid_attrs %{auth_token: nil, refresh_token: nil}

    def spotify_token_fixture(attrs \\ %{}) do
      user = user_fixture()
      {:ok, spotify_token} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Map.put(:user_id, user.id)
        |> Accounts.create_spotify_token()

      spotify_token
    end

    test "list_spotify_tokens/0 returns all spotify_tokens" do
      spotify_token = spotify_token_fixture()
      assert Accounts.list_spotify_tokens() == [spotify_token]
    end

    test "get_spotify_token!/1 returns the spotify_token with given id" do
      spotify_token = spotify_token_fixture()
      assert Accounts.get_spotify_token!(spotify_token.user_id) == spotify_token
    end

    test "create_spotify_token/1 with valid data creates a spotify_token" do
      user = user_fixture()
      assert {:ok, %SpotifyToken{} = spotify_token} = @valid_attrs
      |> Map.put(:user_id, user.id)
      |> Accounts.create_spotify_token()
      assert spotify_token.auth_token == "some auth_token"
      assert spotify_token.refresh_token == "some refresh_token"
    end

    test "create_spotify_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_spotify_token(@invalid_attrs)
    end

    test "update_spotify_token/2 with valid data updates the spotify_token" do
      spotify_token = spotify_token_fixture()
      assert {:ok, %SpotifyToken{} = spotify_token} = Accounts.update_spotify_token(spotify_token, @update_attrs)
      assert spotify_token.auth_token == "some updated auth_token"
      assert spotify_token.refresh_token == "some updated refresh_token"
    end

    test "update_spotify_token/2 with invalid data returns error changeset" do
      spotify_token = spotify_token_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_spotify_token(spotify_token, @invalid_attrs)
      assert spotify_token == Accounts.get_spotify_token!(spotify_token.user_id)
    end

    test "delete_spotify_token/1 deletes the spotify_token" do
      spotify_token = spotify_token_fixture()
      assert {:ok, %SpotifyToken{}} = Accounts.delete_spotify_token(spotify_token)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_spotify_token!(spotify_token.user_id) end
    end

    test "change_spotify_token/1 returns a spotify_token changeset" do
      spotify_token = spotify_token_fixture()
      assert %Ecto.Changeset{} = Accounts.change_spotify_token(spotify_token)
    end
  end
end
