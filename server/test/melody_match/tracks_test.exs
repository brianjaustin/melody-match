defmodule MelodyMatch.TracksTest do
  use MelodyMatch.DataCase

  alias MelodyMatch.Accounts
  alias MelodyMatch.Tracks

  describe "top_tracks" do
    alias MelodyMatch.Tracks.TopTrack

    @valid_attrs %{acousticness: 120.5, danceability: 120.5, energy: 120.5, instrumentalness: 120.5, liveness: 120.5, loudness: 120.5, mode: 120.5, speechiness: 120.5, tempo: 120.5, track_id: "some track_id", valence: 120.5}
    @update_attrs %{acousticness: 456.7, danceability: 456.7, energy: 456.7, instrumentalness: 456.7, liveness: 456.7, loudness: 456.7, mode: 456.7, speechiness: 456.7, tempo: 456.7, track_id: "some updated track_id", valence: 456.7}
    @invalid_attrs %{track_id: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(%{email: "some@example.com", name: "some name", password: "super_strong_pass1234"})
        |> Accounts.create_user()

      user
    end

    def top_track_fixture(attrs \\ %{}) do
      user = user_fixture()

      {:ok, top_track} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Map.put(:user_id, user.id)
        |> Tracks.create_top_track()

      top_track
    end

    test "list_top_tracks/0 returns all top_tracks" do
      top_track = top_track_fixture()
      assert Tracks.list_top_tracks() == [top_track]
    end

    test "get_top_track!/1 returns the top_track with given id" do
      top_track = top_track_fixture()
      assert Tracks.get_top_track!(top_track.id) == top_track
    end

    test "create_top_track/1 with valid data creates a top_track" do
      user = user_fixture()
      assert {:ok, %TopTrack{} = top_track} = @valid_attrs
      |> Map.put(:user_id, user.id)
      |> Tracks.create_top_track()

      assert top_track.acousticness == 120.5
      assert top_track.danceability == 120.5
      assert top_track.energy == 120.5
      assert top_track.instrumentalness == 120.5
      assert top_track.liveness == 120.5
      assert top_track.loudness == 120.5
      assert top_track.mode == 120.5
      assert top_track.speechiness == 120.5
      assert top_track.tempo == 120.5
      assert top_track.track_id == "some track_id"
      assert top_track.valence == 120.5
    end

    test "create_top_track/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tracks.create_top_track(@invalid_attrs)
    end

    test "update_top_track/2 with valid data updates the top_track" do
      top_track = top_track_fixture()
      assert {:ok, %TopTrack{} = top_track} = Tracks.update_top_track(top_track, @update_attrs)
      assert top_track.acousticness == 456.7
      assert top_track.danceability == 456.7
      assert top_track.energy == 456.7
      assert top_track.instrumentalness == 456.7
      assert top_track.liveness == 456.7
      assert top_track.loudness == 456.7
      assert top_track.mode == 456.7
      assert top_track.speechiness == 456.7
      assert top_track.tempo == 456.7
      assert top_track.track_id == "some updated track_id"
      assert top_track.valence == 456.7
    end

    test "update_top_track/2 with invalid data returns error changeset" do
      top_track = top_track_fixture()
      assert {:error, %Ecto.Changeset{}} = Tracks.update_top_track(top_track, @invalid_attrs)
      assert top_track == Tracks.get_top_track!(top_track.id)
    end

    test "delete_top_track/1 deletes the top_track" do
      top_track = top_track_fixture()
      assert {:ok, %TopTrack{}} = Tracks.delete_top_track(top_track)
      assert_raise Ecto.NoResultsError, fn -> Tracks.get_top_track!(top_track.id) end
    end

    test "change_top_track/1 returns a top_track changeset" do
      top_track = top_track_fixture()
      assert %Ecto.Changeset{} = Tracks.change_top_track(top_track)
    end
  end
end
