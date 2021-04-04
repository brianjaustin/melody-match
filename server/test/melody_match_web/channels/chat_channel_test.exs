defmodule MelodyMatchWeb.ChatChannelTest do
  use MelodyMatchWeb.ChannelCase

  alias MelodyMatch.Accounts
  alias MelodyMatch.Matches

  setup do
    {:ok, user1} = %{email: "ch1@example.com", name: "some name1", password: "super_strong_pass1234"}
    |> Accounts.create_user()
    {:ok, user2} = %{email: "ch2@example.com", name: "some name2", password: "super_strong_pass1234"}
    |> Accounts.create_user()

    {:ok, match} = %{first_user_id: user1.id, second_user_id: user2.id}
    |> Matches.create_match()

    %{user1: user1, user2: user2, match: match}
  end

  test "sendMessage with no token", %{match: match} do
    {:error, %{reason: "unauthorized"}} = MelodyMatchWeb.UserSocket
    |> socket()
    |> subscribe_and_join(MelodyMatchWeb.ChatChannel, "chat:#{match.id}")
  end

  test "sendMessage with wrong user id", %{match: match} do
    token = Phoenix.Token.sign(MelodyMatchWeb.Endpoint, "user_id", -1)
    {:error, %{reason: "unauthorized"}} = MelodyMatchWeb.UserSocket
    |> socket()
    |> subscribe_and_join(MelodyMatchWeb.ChatChannel,
      "chat:#{match.id}", %{"token" => token})
  end

  test "sendMessage broadcasts with sender name", %{user1: user1, match: match} do
    token = Phoenix.Token.sign(MelodyMatchWeb.Endpoint, "user_id", user1.id)
    {:ok, _, socket} = MelodyMatchWeb.UserSocket
    |> socket()
    |> subscribe_and_join(MelodyMatchWeb.ChatChannel,
      "chat:#{match.id}", %{"token" => token})

    user_name = user1.name
    push(socket, "sendChatMessage", %{"token" => token, "message" => "hi there"})
    assert_broadcast "receiveChatMessage", %{sender: ^user_name, message: "hi there"}
  end
end
