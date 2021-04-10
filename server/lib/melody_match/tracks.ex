defmodule MelodyMatch.Tracks do
  @moduledoc """
  The Tracks context.
  """

  import Ecto.Query, warn: false
  alias MelodyMatch.Repo

  alias MelodyMatch.Tracks.TopTrack

  @doc """
  Returns the list of top_tracks.

  ## Examples

      iex> list_top_tracks()
      [%TopTrack{}, ...]

  """
  def list_top_tracks do
    Repo.all(TopTrack)
  end

  @doc """
  Gets a single top_track.

  Raises `Ecto.NoResultsError` if the Top track does not exist.

  ## Examples

      iex> get_top_track!(123)
      %TopTrack{}

      iex> get_top_track!(456)
      ** (Ecto.NoResultsError)

  """
  def get_top_track!(id), do: Repo.get!(TopTrack, id)

  @doc """
  Creates a top_track.

  ## Examples

      iex> create_top_track(%{field: value})
      {:ok, %TopTrack{}}

      iex> create_top_track(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_top_track(attrs \\ %{}) do
    IO.puts "got to making top track"
    %TopTrack{}
    |> TopTrack.changeset(attrs)
    |> Repo.insert(on_conflict: :replace_all, conflict_target: [:user_id])
  end

  @doc """
  Updates a top_track.

  ## Examples

      iex> update_top_track(top_track, %{field: new_value})
      {:ok, %TopTrack{}}

      iex> update_top_track(top_track, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_top_track(%TopTrack{} = top_track, attrs) do
    top_track
    |> TopTrack.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a top_track.

  ## Examples

      iex> delete_top_track(top_track)
      {:ok, %TopTrack{}}

      iex> delete_top_track(top_track)
      {:error, %Ecto.Changeset{}}

  """
  def delete_top_track(%TopTrack{} = top_track) do
    Repo.delete(top_track)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking top_track changes.

  ## Examples

      iex> change_top_track(top_track)
      %Ecto.Changeset{data: %TopTrack{}}

  """
  def change_top_track(%TopTrack{} = top_track, attrs \\ %{}) do
    TopTrack.changeset(top_track, attrs)
  end
end
