defmodule MelodyMatch.Matchmaker.MatcherBase do
  @moduledoc """
  Base types and behaviour for potential matchers to be used
  in matchmaking. This allows for easier testing, both manual
  and unit.
  """

  @typedoc """
  Represents the parameters used to match a user. Includes the
  characteristics of their top track (song) and their last
  recorded location (latitude/longitude).
  """
  @type matching_params :: %{
    acousticness: float,
    danceability: float,
    energy: float,
    instrumentalness: float,
    liveness: float,
    loudness: float,
    mode: float,
    speechiness: float,
    tempo: float,
    valence: float,
    latitude: String.t,
    longitude: String.t
  }

  @typedoc """
  Represents a pool of users who can be matched with; consists of
  user id mapped to their matching parameters.
  """
  @type available_matches :: %{
    integer => matching_params
  }

  @doc """
  Retrieves the best match available for a user and pool of available
  matches. What this means (and the matching threshold) depends on
  specific implementations.
  """
  @callback best_match(matching_params, available_matches) :: integer | nil
end
