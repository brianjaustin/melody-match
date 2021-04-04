defmodule MelodyMatchWeb.MatchmakerChannelTest do
  use MelodyMatchWeb.ChannelCase

  import Mox

  alias MelodyMatch.Accounts
  alias MelodyMatch.Matchmaker
  alias MelodyMatch.Matchmaker.MatcherMock
  alias MelodyMatchWeb.MatchmakerChannel

  setup :set_mox_from_context
  setup :verify_on_exit!

  setup do
    start_supervised!({Matchmaker, "*"})

    {:ok, user} = %{email: "ch1@example.com", name: "some name", password: "super_strong_pass1234"}
    |> Accounts.create_user()
    %{user: user}
  end

  test "join with no token", %{user: _user} do
    {:error, %{reason: "unauthorized"}} = socket(MelodyMatchWeb.UserSocket)
      |> subscribe_and_join(MatchmakerChannel, "matchmaker:1")
  end

  test "join with wrong token", %{user: _user} do
    token = Phoenix.Token.sign(MelodyMatchWeb.Endpoint, "user_id", 1)
    {:error, %{reason: "unauthorized"}} = socket(MelodyMatchWeb.UserSocket)
      |> subscribe_and_join(MatchmakerChannel, "matchmaker:2", %{"token" => token})
  end

  test "join with no match", %{user: user} do
    expect(MatcherMock, :best_match, fn _, %{} -> nil end)

    token = Phoenix.Token.sign(MelodyMatchWeb.Endpoint, "user_id", user.id)
    {:ok, _, _socket} = socket(MelodyMatchWeb.UserSocket)
      |> subscribe_and_join(MatchmakerChannel, "matchmaker:#{user.id}", %{"token" => token})
  end

  test "join with with match", %{user: user} do
    {:ok, user2} = %{email: "ch2@example.com", name: "some name", password: "super_strong_pass1234"}
    |> Accounts.create_user()

    expect(MatcherMock, :best_match, fn _, %{} -> user2.id end)

    token = Phoenix.Token.sign(MelodyMatchWeb.Endpoint, "user_id", user.id)
    {:ok, _, _socket} = socket(MelodyMatchWeb.UserSocket)
      |> subscribe_and_join(MatchmakerChannel, "matchmaker:#{user.id}", %{"token" => token})

    assert_broadcast "matchFound", %{matchId: match_id}
    assert match_id
  end
end
