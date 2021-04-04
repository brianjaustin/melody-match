defmodule MelodyMatchWeb.MatchmakerChannelTest do
  use MelodyMatchWeb.ChannelCase

  import Mox

  alias MelodyMatch.Matchmaker
  alias MelodyMatch.Matchmaker.MatcherMock
  alias MelodyMatchWeb.MatchmakerChannel

  setup :set_mox_from_context
  setup :verify_on_exit!

  setup do
    start_supervised!({Matchmaker, "*"})
    :ok
  end

  test "join with no token" do
    {:error, %{reason: "unauthorized"}} = socket(MelodyMatchWeb.UserSocket)
      |> subscribe_and_join(MatchmakerChannel, "matchmaker:1")
  end

  test "join with wrong token" do
    token = Phoenix.Token.sign(MelodyMatchWeb.Endpoint, "user_id", 1)
    {:error, %{reason: "unauthorized"}} = socket(MelodyMatchWeb.UserSocket)
      |> subscribe_and_join(MatchmakerChannel, "matchmaker:2", %{"token" => token})
  end

  test "join with no match" do
    expect(MatcherMock, :best_match, fn _, %{} -> nil end)

    token = Phoenix.Token.sign(MelodyMatchWeb.Endpoint, "user_id", 1)
    {:ok, _, _socket} = socket(MelodyMatchWeb.UserSocket)
      |> subscribe_and_join(MatchmakerChannel, "matchmaker:1", %{"token" => token})
  end

  test "join with with match" do
    expect(MatcherMock, :best_match, fn _, %{} -> 2 end)

    token = Phoenix.Token.sign(MelodyMatchWeb.Endpoint, "user_id", 1)
    {:ok, _, _socket} = socket(MelodyMatchWeb.UserSocket)
      |> subscribe_and_join(MatchmakerChannel, "matchmaker:1", %{"token" => token})

    assert_broadcast "matchFound", %{matchId: nil}
  end
end
