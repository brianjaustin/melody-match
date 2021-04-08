defmodule MelodyMatchWeb.MatchmakerChannel do
  use MelodyMatchWeb, :channel

  alias MelodyMatch.Matchmaker

  @matchmaker_id "*"

  @impl true
  def join("matchmaker:" <> user_id, payload, socket) do
    if authorized?(user_id, payload) do
      {user_id, _} = Integer.parse(user_id)
      Matchmaker.start(@matchmaker_id)
      Matchmaker.try_match(@matchmaker_id, user_id)

      {:ok, assign(socket, :user_id, user_id)}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def terminate(_, socket) do
    user_id = socket.assigns[:user_id]
    if user_id do
      Matchmaker.remove_user(@matchmaker_id, user_id)
    end

    nil
  end

  defp authorized?(user_id, %{} = payload)  do
    token = Map.get(payload, "token")

    with {:ok, tok_user_id} <- Phoenix.Token.verify(
      MelodyMatchWeb.Endpoint, "user_id", token, max_age: 86400)
    do
      user_id == "#{tok_user_id}"
    else
      _ -> false
    end
  end

  defp authorized?(_, _), do: false
end
