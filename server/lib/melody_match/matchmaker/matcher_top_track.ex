defmodule MelodyMatch.Matchmaker.MatcherTopTrack do
  @moduledoc """
  Production-ready matching algorithm that matches based on
  similarity of users' top tracks.
  """

  @behaviour MelodyMatch.Matchmaker.MatcherBase

  @minimum_diff 50
  @max_location_meters 500_000

  @impl true
  def best_match(_, _, pool) when map_size(pool) == 0, do: nil

  @impl true
  def best_match(recent_partners, user, pool) do
    {other_id, _} = pool
    |> Enum.filter(fn {id, _} -> !Enum.member?(recent_partners, id) end)
    |> Enum.filter(fn {_, traits} -> close_enough(user, traits) end)
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

    abs(diff_raw) * 1000
  end

  defp close_enough(%{latitude: nil, longitude: nil}, %{latitude: nil, longitude: nil}) do
    true
  end

  defp close_enough(%{latitude: lat1, longitude: long1}, %{latitude: lat2, longitude: long2}) do
    cond do
      (lat1 == nil) || (long1 == nil) -> false
      (lat2 == nil) || (long2 == nil) -> false
      true -> close_enough(lat1, long1, lat2, long2)
    end
  end

  defp close_enough(_, _), do: false

  defp close_enough(lat1, long1, lat2, long2) do
    with {lat1, _} <- Float.parse(lat1),
         {long1, _} <- Float.parse(long1),
         {lat2, _} <- Float.parse(lat2),
         {long2, _} <- Float.parse(long2)
    do
      point1 = %{lat: lat1, lon: long1}
      point2 = %{lat: lat2, lon: long2}
      Geocalc.distance_between(point1, point2) <= @max_location_meters
    else
      _ -> false
    end
  end
end
