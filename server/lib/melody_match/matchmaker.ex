defmodule MelodyMatch.Matchmaker do
  @moduledoc """
  Server for matching users on the system with each other.
  Which matcher is configurable via application config,
  for example

  ```elixir
  config :melody_match,
    default_matcher: MelodyMatch.Matchmaker.MatcherAny
  ```

  ## Attribution

    The code in this module is based on lecture notes, see
    https://github.com/NatTuck/scratch-2021-01/blob/master/4550/0219/hangman/lib/hangman/game_server.ex.
  """

  use GenServer

  alias MelodyMatch.Accounts
  alias MelodyMatch.Matches
  alias MelodyMatch.MatchmakerSupervisor
  alias MelodyMatch.PoolBackupAgent
  alias MelodyMatch.Repo

  # Public interface

  def start(name) do
    spec = %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [name]},
      restart: :permanent,
      type: :worker
    }
    MatchmakerSupervisor.start_child(spec)
  end

  def start_link(name) do
    pool = PoolBackupAgent.get(name) || %{}
    GenServer.start_link(__MODULE__, pool, name: reg(name))
  end

  @doc """
  Attempt to match the user with the given ID to users who
  are available for matching currently.

  ## Arguments

    - matchmaker_name: the matchmaker server instance to use;
      for now, this should always be the same value
    - user_id: ID of the user to try matching
  """
  @spec try_match(String.t, integer) :: term
  def try_match(matchmaker_name, user_id) do
    GenServer.call(reg(matchmaker_name), {:try_match, user_id})
  end

  @doc """
  Removes the given user from the matchmaking pool.

  ## Arguments

    - matchmaker_name: the matchmaker server instance to use
    - user_id: ID of the user to remove
  """
  @spec remove_user(String.t, integer) :: term
  def remove_user(matchmaker_name, user_id) do
    GenServer.call(reg(matchmaker_name), {:remove_user, user_id})
  end

  defp reg(name), do: {:via, Registry, {MelodyMatch.MatchmakerRegistry, name}}

  # Implementation

  def init(pool), do: {:ok, pool}

  def handle_call({:try_match, user_id}, _from, pool) do
    params = get_matching_params(user_id)
    other_user_id = matcher().best_match(params, pool)

    if other_user_id do
      {:ok, match} = %{first_user_id: other_user_id, second_user_id: user_id}
      |> Matches.create_match()
      send_match_found(user_id, match.id)
      send_match_found(other_user_id, match.id)

      {:reply, other_user_id, Map.delete(pool, other_user_id)}
    else
      {:reply, nil, Map.put(pool, user_id, params)}
    end
  end

  def handle_call({:remove_user, user_id}, _from, pool) do
    {:reply, nil, Map.delete(pool, user_id)}
  end

  defp get_matching_params(user_id) do
    user = Accounts.get_user!(user_id)
    |> Repo.preload(:top_track)

    if user.top_track do
      user.top_track
      |> Enum.into(%{latitude: user.last_latitude, longitude: user.last_longitude})
    else
      %{latitude: user.last_latitude, longitude: user.last_longitude}
    end
  end

  defp matcher(), do: Application.get_env(:melody_match, :default_matcher)

  defp send_match_found(user_id, match_id) do
    IO.puts "Broadcasting matches #{user_id} match Found"
    MelodyMatchWeb.Endpoint.broadcast(
      "matchmaker:#{user_id}",
      "matchFound",
      %{matchId: match_id})
  end
end
