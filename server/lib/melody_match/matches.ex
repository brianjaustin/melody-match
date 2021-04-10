defmodule MelodyMatch.Matches do
  @moduledoc """
  The Matches context.
  """

  import Ecto.Query, warn: false
  alias MelodyMatch.Repo

  alias MelodyMatch.Matches.Match

  @doc """
  Returns the list of matches.

  ## Examples

      iex> list_matches()
      [%Match{}, ...]

  """
  def list_matches do
    Repo.all(Match)
  end

  @doc """
  Gets a single match.

  Raises `Ecto.NoResultsError` if the Match does not exist.

  ## Examples

      iex> get_match!(123)
      %Match{}

      iex> get_match!(456)
      ** (Ecto.NoResultsError)

  """
  def get_match!(id), do: Repo.get!(Match, id)

  @doc """
  Gets a list of matches by user id (either first or second user involved).
  """
  def get_matches_by_user_id(id) do
    query = from m in Match,
      where: m.first_user_id == ^id or m.second_user_id == ^id
    Repo.all(query)
  end

  @doc """
  Gets a list of matches by user id where the match occured
  `delta_hours` (default = 24) ago.
  """
  def get_user_recent_matches(user_id, delta_hours \\ 24) do
    cutoff = DateTime.utc_now()
    |> DateTime.add(-1 * delta_hours * 60 * 60)
    |> DateTime.to_naive()

    query = from m in Match,
      where: (m.first_user_id == ^user_id or m.second_user_id == ^user_id) \
      and m.updated_at > ^cutoff
    Repo.all(query)
  end

  @doc """
  Creates a match.

  ## Examples

      iex> create_match(%{field: value})
      {:ok, %Match{}}

      iex> create_match(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_match(attrs \\ %{}) do
    %Match{}
    |> Match.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a match.

  ## Examples

      iex> delete_match(match)
      {:ok, %Match{}}

      iex> delete_match(match)
      {:error, %Ecto.Changeset{}}

  """
  def delete_match(%Match{} = match) do
    Repo.delete(match)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking match changes.

  ## Examples

      iex> change_match(match)
      %Ecto.Changeset{data: %Match{}}

  """
  def change_match(%Match{} = match, attrs \\ %{}) do
    Match.changeset(match, attrs)
  end
end
