defmodule MelodyMatch.Matchmaker.MatcherTopTrack do
  @moduledoc """
  Production-ready matching algorithm that matches based on
  similarity of users' top tracks.
  """

  @behaviour MelodyMatch.Matchmaker.MatcherBase

  @minimum_diff 50

  @impl true
  def best_match(_user, pool) when map_size(pool) == 0, do: nil

  @impl true
  def best_match(user, pool) do
    {other_id, _} = pool
    |> Enum.map(fn {id, traits} -> {id, traits_difference(user, traits)} end)
    |> Enum.filter(fn {_, diff} -> diff <= @minimum_diff end)
    |> Enum.min(fn {_, diff1}, {_, diff2} -> diff1 <= diff2 end, fn -> {nil, nil} end)
    other_id
  end

  defp traits_difference(a, b) do
    danceability_diff = a.danceability - b.danceability
    acousticness_diff = a.acousticness - b.acousticness
    energy_diff = a.energy - b.energy
    instrumentalness_diff = a.instrumentalness - b.instrumentalness
    liveness_diff = a.liveness - b.liveness
    loudness_diff = a.loudness - b.loudness
    speechiness_diff = a.speechiness - b.speechiness
    valence_diff = a.valence - b.valence
    tempo_diff = a.tempo - b.tempo

    diff_raw = (danceability_diff + acousticness_diff + energy_diff \
      + instrumentalness_diff + liveness_diff + loudness_diff + speechiness_diff \
      + valence_diff + tempo_diff) / 9

    abs(diff_raw) * 10000
  end
end
