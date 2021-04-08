defmodule MelodyMatch.Matchmaker.MatcherAny do
  @moduledoc """
  Matcher that returns a random match for the given user.
  Useful for testing, but not the production algorithm.
  """

  @behaviour MelodyMatch.Matchmaker.MatcherBase

  @impl true
  def best_match(_user, pool) when map_size(pool) == 0, do: nil

  @impl true
  def best_match(_user, pool) do
    pool
    |> Map.keys()
    |> Enum.random()
  end
end
