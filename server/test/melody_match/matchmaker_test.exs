defmodule MelodyMatch.MatchmakerTest do
  use MelodyMatch.DataCase

  import Mox

  alias MelodyMatch.Accounts
  alias MelodyMatch.Matchmaker
  alias MelodyMatch.Matchmaker.MatcherMock

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
  end
end
