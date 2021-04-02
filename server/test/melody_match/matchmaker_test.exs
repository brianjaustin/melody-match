defmodule MelodyMatch.MatchmakerTest do
  use ExUnit.Case

  import Mox

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
      expect(MatcherMock, :best_match, fn _, %{} -> nil end)
      expect(MatcherMock, :best_match, fn _, %{1 => %{}} -> nil end)

      assert Matchmaker.try_match(@matchmaker_id, 1) == nil
      assert Matchmaker.try_match(@matchmaker_id, 2) == nil
    end

    test "adds to existing pool if no match found" do
      expect(MatcherMock, :best_match, fn _, %{} -> nil end)
      expect(MatcherMock, :best_match, fn _, %{1 => %{}} -> nil end)
      expect(MatcherMock, :best_match, fn _, %{1 => %{}, 2 => %{}} -> nil end)

      assert Matchmaker.try_match(@matchmaker_id, 1) == nil
      assert Matchmaker.try_match(@matchmaker_id, 2) == nil
      assert Matchmaker.try_match(@matchmaker_id, 3) == nil
    end

    test "removes from pool if a match is found" do
      expect(MatcherMock, :best_match, fn _, %{} -> nil end)
      expect(MatcherMock, :best_match, fn _, %{1 => %{}} -> 1 end)
      expect(MatcherMock, :best_match, fn _, pool ->
        # Check that the pool is exactly empty (pattern match
        # won't do it)
        assert pool == %{}
        nil
      end)

      assert Matchmaker.try_match(@matchmaker_id, 1) == nil
      assert Matchmaker.try_match(@matchmaker_id, 2) == 1
      assert Matchmaker.try_match(@matchmaker_id, 3) == nil
    end
  end
end
