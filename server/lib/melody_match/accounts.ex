defmodule MelodyMatch.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias MelodyMatch.Repo

  alias MelodyMatch.Accounts.User
  alias MelodyMatch.Accounts.SpotifyToken

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates a user's password hash in the database.
  """
  def update_password(%User{} = user, attrs) do
    user
    |> User.update_password_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  @doc """
  Returns the list of spotify_tokens.

  ## Examples

      iex> list_spotify_tokens()
      [%SpotifyToken{}, ...]

  """
  def list_spotify_tokens do
    Repo.all(SpotifyToken)
  end

  @doc """
  Gets a single spotify_token.

  Raises `Ecto.NoResultsError` if the Spotify token does not exist.

  ## Examples

      iex> get_spotify_token!(123)
      %SpotifyToken{}

      iex> get_spotify_token!(456)
      ** (Ecto.NoResultsError)

  """
  def get_spotify_token!(id), do: Repo.get!(SpotifyToken, id)

  @doc """
  Gets a spotify_token with the given `user_id`.

  Raises `Ecto.NoResultsError` if the token does not exist for the user.
  """
  def get_user_spotify_token!(user_id) do
    Repo.get_by!(SpotifyToken, user_id: user_id)
  end

  @doc """
  Creates a spotify_token.

  ## Examples

      iex> create_spotify_token(%{field: value})
      {:ok, %SpotifyToken{}}

      iex> create_spotify_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_spotify_token(attrs \\ %{}) do
    %SpotifyToken{}
    |> SpotifyToken.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a spotify_token.

  ## Examples

      iex> update_spotify_token(spotify_token, %{field: new_value})
      {:ok, %SpotifyToken{}}

      iex> update_spotify_token(spotify_token, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_spotify_token(%SpotifyToken{} = spotify_token, attrs) do
    spotify_token
    |> SpotifyToken.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a spotify_token.

  ## Examples

      iex> delete_spotify_token(spotify_token)
      {:ok, %SpotifyToken{}}

      iex> delete_spotify_token(spotify_token)
      {:error, %Ecto.Changeset{}}

  """
  def delete_spotify_token(%SpotifyToken{} = spotify_token) do
    Repo.delete(spotify_token)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking spotify_token changes.

  ## Examples

      iex> change_spotify_token(spotify_token)
      %Ecto.Changeset{data: %SpotifyToken{}}

  """
  def change_spotify_token(%SpotifyToken{} = spotify_token, attrs \\ %{}) do
    SpotifyToken.changeset(spotify_token, attrs)
  end
end
