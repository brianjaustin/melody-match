defmodule Spotify do
  @moduledoc """
  Wrapper functions for interacting with the Spotify API.
  By default, they will retry with a refreshed API token if the
  initial request fails. This may be bypassed by specifying
  0 retries.
  """

  alias MelodyMatch.Accounts
  alias MelodyMatch.Tracks

  @doc """
  Given a user id and an authorization code (fetched somewhere else,
  likely in the React frontend), retrieve `access_code` and
  `refresh_token` using the Spotify API and save it to the database for later use.

  ## Arguments

    - user_id: ID of the user whose access tokens will be saved
    - :code: atom representing the request type (one of :code, :refresh)
    - code: access code from OAuth grant, must be fetched separately
    - redirect_uri: string representation of the uri to call back to once the token is saved
  """
  def get_and_save_tokens(user_id, :code, code, redirect_uri) do
    url = "https://accounts.spotify.com/api/token"

    body = {:form, [
      {"grant_type", "authorization_code"},
      {"code", code},
      {"redirect_uri", redirect_uri}
    ]}
    response = HTTPoison.post!(url, body, auth_headers())
    if response.status_code == 200 do
      toks = Jason.decode!(response.body)

      spotify_token = Accounts.create_spotify_token(%{
        user_id: user_id,
        auth_token: toks["access_token"],
        refresh_token: toks["refresh_token"]
      })
      top_track_id = get_top_song_id(user_id)
      top_song = get_top_song_info(user_id, top_track_id)
      top_track = %{user_id: String.to_integer(user_id), 
                    track_id: top_song["id"],
                    acousticness: top_song["acousticness"],
                    danceability: top_song["danceability"],
                    energy: top_song["energy"],
                    instrumentalness: top_song["instrumentalness"],
                    liveness: top_song["liveness"],
                    loudness: top_song["loudness"],
                    mode: top_song["mode"],
                    speechiness: top_song["speechiness"],
                    tempo: top_song["tempo"],
                    valence: top_song["valence"]}
      Tracks.create_top_track(top_track)
      spotify_token
    else
      {:error, response.status_code, response.body}
    end
  end

  @doc """
  Given a user id, use the existing refresh token to obtain a
  new refresh token.

  ## Arguments

    - user_id: ID of the user whose access token to refresh
    - :refresh: atom representing the request type (one of :code, :refresh)
  """
  def get_and_save_tokens(user_id, :refresh) do
    tokens = Accounts.get_user_spotify_token!(user_id)

    url = "https://accounts.spotify.com/api/token"
    body = {:form, [
      {"grant_type", "refresh_token"},
      {"refresh_token", tokens.refresh_token}
    ]}
    response = HTTPoison.post!(url, body, auth_headers())

    if response.status_code == 200 do
      toks = Jason.decode!(response.body)

      Accounts.update_spotify_token(tokens, %{
        auth_token: toks["access_token"],
      })
    else
      {:error, response.status_code, response.body}
    end
  end

  defp auth_headers() do
    client_id = Application.get_env(:melody_match, :spotify)[:client_id]
    client_secret = Application.get_env(:melody_match, :spotify)[:client_secret]
    auth = Base.encode64("#{String.trim(client_id)}:#{String.trim(client_secret)}")
    ["Authorization": "Basic #{auth}", "Content-Type": "application/x-www-form-urlencoded"]
  end

 def get_top_song_id(user_id, limit \\ 1, retries \\ 1) do
    tokens = Accounts.get_user_spotify_token!(user_id)

    url = "https://api.spotify.com/v1/me/top/tracks?limit=#{limit}"
    headers = ["Authorization": "Bearer #{tokens.auth_token}"]
    response = HTTPoison.get!(url, headers)
    cond do
      response.status_code == 200 ->
        songs = response.body
        |> Jason.decode!()
        |> Map.get("items")
        |> hd()        
        |> Map.get("id")
        songs
      retries > 0 ->
        get_and_save_tokens(tokens.user_id, :refresh)
        get_top_song_id(user_id, limit, retries - 1)
      true ->
        {:error, response.status_code, "Error fetching top tracks."}
    end
  end

 def get_top_song_info(user_id, track_id, retries \\ 1) do
    tokens = Accounts.get_user_spotify_token!(user_id)

    url = "https://api.spotify.com/v1/audio-features/#{track_id}"
    headers = ["Authorization": "Bearer #{tokens.auth_token}"]
    response = HTTPoison.get!(url, headers)

    cond do
      response.status_code == 200 ->
        songs = response.body
        |> Jason.decode!()
        songs
      retries > 0 ->
        get_top_song_info(user_id, track_id, retries - 1)
      true ->
        {:error, response.status_code, "Error fetching track info."}
    end
  end


  def get_spotify_data(user_id, limit \\ 1, retries \\ 1) do
    tokens = Accounts.get_user_spotify_token!(user_id)

    url = "https://api.spotify.com/v1/me/top/tracks?limit=#{limit}"
    headers = ["Authorization": "Bearer #{tokens.auth_token}"]
    response = HTTPoison.get!(url, headers)

    cond do
      response.status_code == 200 ->
        songs = response.body
        |> Jason.decode!()
        {:ok, songs}
      retries > 0 ->
        get_and_save_tokens(tokens.user_id, :refresh)
        get_spotify_data(user_id, limit, retries - 1)
      true ->
        {:error, response.status_code, "Error fetching from Spotify."}
    end
  end

end
