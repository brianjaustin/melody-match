defmodule MelodyMatch.Matchmaker do
  @moduledoc """
  Server for matching users on the system with each other.
  Which matcher is configurable via application config,
  for example

  ```elixir
  config :melody_match,
    default_matcher: MelodyMatch.Matchmaker.MatcherAny
  ```
  """

  use GenServer

  alias MelodyMatch.Accounts
  alias MelodyMatch.MatchmakerSupervisor

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
    pool = %{} # TODO : backup agent
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

  defp reg(name), do: {:via, Registry, {MelodyMatch.MatchmakerRegistry, name}}

  # Implementation

  def init(pool), do: {:ok, pool}

  def handle_call({:try_match, user_id}, _from, pool) do
    # TODO : get matching parameters
    other_user_id = matcher().best_match(%{}, pool)

    # TODO : send to channels
    if other_user_id do
      {:reply, other_user_id, Map.delete(pool, other_user_id)}
    else
      {:reply, nil, Map.put(pool, user_id, %{})}
    end
  end

  defp matcher(), do: Application.get_env(:melody_match, :default_matcher)
end
