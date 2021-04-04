defmodule MelodyMatchWeb.ChatChannel do
  use MelodyMatchWeb, :channel

  alias MelodyMatch.Accounts
  alias MelodyMatch.Matches

  @impl true
  def join("chat:" <> match_id, payload, socket) do
    if authorized?(match_id, payload) do
      token = Map.get(payload, "token")
      user_id = token_to_user_id(token)
      user = Accounts.get_user!(user_id)

      users = socket.assigns[:users] || %{}
      |> Map.put(user_id, user)

      {:ok, assign(socket, :users, users)}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_in("sendChatMessage", payload, socket) do
    users = socket.assigns[:users]
    token = Map.get(payload, "token")
    user_id = token_to_user_id(token)
    user = Map.get(users, user_id)
    message = Map.get(payload, "message")

    broadcast socket, "receiveChatMessage", %{
      message: message,
      sender: user.name
    }
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(match_id, %{"token" => token}) do
    match = Matches.get_match!(match_id)
    user_id = token_to_user_id(token)
    (user_id == match.first_user_id) || (user_id == match.second_user_id)
  end

  defp authorized?(_, _), do: false

  defp token_to_user_id(token) do
    with {:ok, tok_user_id} <- Phoenix.Token.verify(
        MelodyMatchWeb.Endpoint, "user_id", token, max_age: 86400)
    do
      tok_user_id
    else
      _ -> nil
    end
  end
end
