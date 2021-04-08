defmodule MelodyMatch.MatchmakerTest do
  use MelodyMatch.DataCase

  import Mox

  alias MelodyMatch.Accounts
  alias MelodyMatch.Matchmaker
  alias MelodyMatch.Matchmaker.MatcherMock
  alias MelodyMatch.Matchmaker.MatcherTopTrack

  @matchmaker_id "*"

  setup :set_mox_from_context
  setup :verify_on_exit!

  setup do
    start_supervised!({Matchmaker, @matchmaker_id})
    :ok
  end

  describe "matchmaker" do
    test "adds to empty pool if no match found" do
      {:ok, user1} = %{email: "mt1@example.com", name: "some name", password: "super_strong_pass1234"}
      |> Accounts.create_user()
      user1_id = user1.id
      {:ok, user2} = %{email: "mt2@example.com", name: "some name", password: "super_strong_pass1234"}
      |> Accounts.create_user()

      expect(MatcherMock, :best_match, fn _, %{} -> nil end)
      expect(MatcherMock, :best_match, fn _, %{^user1_id => %{}} -> nil end)

      assert Matchmaker.try_match(@matchmaker_id, user1_id) == nil
      assert Matchmaker.try_match(@matchmaker_id, user2.id) == nil
    end

    test "adds to existing pool if no match found" do
      {:ok, user1} = %{email: "mt1@example.com", name: "some name", password: "super_strong_pass1234"}
      |> Accounts.create_user()
      user1_id = user1.id
      {:ok, user2} = %{email: "mt2@example.com", name: "some name", password: "super_strong_pass1234"}
      |> Accounts.create_user()
      user2_id = user2.id
      {:ok, user3} = %{email: "mt3@example.com", name: "some name", password: "super_strong_pass1234"}
      |> Accounts.create_user()

      expect(MatcherMock, :best_match, fn _, %{} -> nil end)
      expect(MatcherMock, :best_match, fn _, %{^user1_id => %{}} -> nil end)
      expect(MatcherMock, :best_match, fn _, %{^user1_id => %{}, ^user2_id => %{}} -> nil end)

      assert Matchmaker.try_match(@matchmaker_id, user1_id) == nil
      assert Matchmaker.try_match(@matchmaker_id, user2_id) == nil
      assert Matchmaker.try_match(@matchmaker_id, user3.id) == nil
    end

    test "removes from pool if a match is found" do
      {:ok, user1} = %{email: "mt1@example.com", name: "some name", password: "super_strong_pass1234"}
      |> Accounts.create_user()
      user1_id = user1.id
      {:ok, user2} = %{email: "mt2@example.com", name: "some name", password: "super_strong_pass1234"}
      |> Accounts.create_user()
      {:ok, user3} = %{email: "mt3@example.com", name: "some name", password: "super_strong_pass1234"}
      |> Accounts.create_user()

      expect(MatcherMock, :best_match, fn _, %{} -> nil end)
      expect(MatcherMock, :best_match, fn _, %{^user1_id => %{}} -> user1_id end)
      expect(MatcherMock, :best_match, fn _, pool ->
        # Check that the pool is exactly empty (pattern match
        # won't do it)
        assert pool == %{}
        nil
      end)

      assert Matchmaker.try_match(@matchmaker_id, user1_id) == nil
      assert Matchmaker.try_match(@matchmaker_id, user2.id) == user1_id
      assert Matchmaker.try_match(@matchmaker_id, user3.id) == nil
    end

    test "remove_user does nothing if user not in the pool" do
      Matchmaker.remove_user(@matchmaker_id, -1)
    end

    test "remove_user removes user from the pool if present" do
      {:ok, user1} = %{email: "mt1@example.com", name: "some name", password: "super_strong_pass1234"}
      |> Accounts.create_user()
      {:ok, user2} = %{email: "mt2@example.com", name: "some name", password: "super_strong_pass1234"}
      |> Accounts.create_user()

      expect(MatcherMock, :best_match, fn _, %{} -> nil end)
      expect(MatcherMock, :best_match, fn _, pool ->
        # Check that the pool is exactly empty (pattern match
        # won't do it)
        assert pool == %{}
        nil
      end)

      assert Matchmaker.try_match(@matchmaker_id, user1.id) == nil
      Matchmaker.remove_user(@matchmaker_id, user1.id)
      assert Matchmaker.try_match(@matchmaker_id, user2.id) == nil
    end
  end

  describe "top track matcher" do
    test "returns no match for empty pool" do
      refute MatcherTopTrack.best_match(%{}, %{})
    end

    test "returns best match with no previous matches" do
      traits1 = %{
        acousticness: 0.0,
        danceability: 0.0,
        energy: 0.0,
        instrumentalness: 0.0,
        liveness: 0.0,
        loudness: 0.0,
        mode: 0.0,
        speechiness: 0.0,
        tempo: 0.0,
        valence: 0.0,
        latitude: nil,
        longitude: nil
      }
      traits2 = %{
        acousticness: 0.01,
        danceability: 0.0,
        energy: 0.0,
        instrumentalness: 0.0,
        liveness: 0.0,
        loudness: 0.0,
        mode: 0.0,
        speechiness: 0.0,
        tempo: 0.0,
        valence: 0.0,
        latitude: nil,
        longitude: nil
      }

      assert MatcherTopTrack.best_match(traits1, %{1 => traits1, 2 => traits2}) == 1
    end

    test "returns no match if minimum threshold not met" do
      traits1 = %{
        acousticness: 0.0,
        danceability: 0.0,
        energy: 0.0,
        instrumentalness: 0.0,
        liveness: 0.0,
        loudness: 0.0,
        mode: 0.0,
        speechiness: 0.0,
        tempo: 0.0,
        valence: 0.0,
        latitude: nil,
        longitude: nil
      }
      traits2 = %{
        acousticness: 0.1,
        danceability: 0.0,
        energy: 0.0,
        instrumentalness: 0.0,
        liveness: 0.0,
        loudness: 0.0,
        mode: 0.0,
        speechiness: 0.0,
        tempo: 0.0,
        valence: 0.0,
        latitude: nil,
        longitude: nil
      }

      refute MatcherTopTrack.best_match(traits1, %{1 => traits2, 2 => traits2})
    end
  end
end
