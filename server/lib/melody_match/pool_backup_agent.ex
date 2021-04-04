defmodule MelodyMatch.PoolBackupAgent do
  @moduledoc """
  Agent to backup a matchmaker's pool in case
  the matchmaker server crashes.

  ## Attribution

    Based on the code from lecture notes, see
    https://github.com/NatTuck/scratch-2021-01/blob/master/4550/0219/hangman/lib/hangman/backup_agent.ex.
  """

  use Agent

  alias MelodyMatch.Matchmaker.MatcherBase

  def start_link(_arg),
    do: Agent.start_link(fn -> %{} end, name: __MODULE__)

  @doc """
  Stores the given value at the given key.

  ## Parameters
    - name: the key at which to store the value
    - val: the value to store

  ## Examples
    iex> MelodyMatch.PoolBackupAgent.start_link(nil)
    iex> MelodyMatch.PoolBackupAgent.put("foo", %{a: 1})
    :ok
    iex> MelodyMatch.PoolBackupAgent.put("bar", %{b: 1})
    :ok

    iex> MelodyMatch.PoolBackupAgent.start_link(nil)
    iex> MelodyMatch.PoolBackupAgent.put("foo", %{a: 1})
    :ok
    iex> MelodyMatch.PoolBackupAgent.put("foo", %{b: 1})
    :ok
  """
  @spec put(String.t, MatcherBase.available_matches) :: :ok
  def put(name, val) do
    Agent.update(__MODULE__, fn state ->
      Map.put(state, name, val)
    end)
  end

  @doc """
  Retrieves the value at the given key if availabe. Otherwise,
  returns nil.

  ## Arguments

    - name: the key to query for a value

  ## Examples

    iex> MelodyMatch.PoolBackupAgent.start_link(nil)
    iex> MelodyMatch.PoolBackupAgent.get("baz")
    nil

    iex> MelodyMatch.PoolBackupAgent.start_link(nil)
    iex> MelodyMatch.PoolBackupAgent.put("foo", %{a: 1})
    :ok
    iex> MelodyMatch.PoolBackupAgent.get("foo")
    %{a: 1}
  """
  @spec get(String.t) :: MatcherBase.available_matches | nil
  def get(name) do
    Agent.get(__MODULE__, fn state ->
      Map.get(state, name)
    end)
  end
end
