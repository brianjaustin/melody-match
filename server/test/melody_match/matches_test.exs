defmodule MelodyMatch.MatchesTest do
  use MelodyMatch.DataCase

  alias MelodyMatch.Accounts
  alias MelodyMatch.Matches
  alias MelodyMatch.Repo

  describe "matches" do
    alias MelodyMatch.Matches.Match

    @valid_attrs %{}
    @invalid_attrs %{}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(%{email: "some@example.com", name: "some name", password: "super_strong_pass1234"})
        |> Accounts.create_user()

      user
    end

    def match_fixture(attrs \\ %{}) do
      first_user = user_fixture(%{email: "u1@example.com"})
      second_user = user_fixture(%{email: "u2@example.com"})

      {:ok, match} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Map.put(:first_user_id, first_user.id)
        |> Map.put(:second_user_id, second_user.id)
        |> Matches.create_match()

      match
    end

    test "list_matches/0 returns all matches" do
      match = match_fixture()
      assert Matches.list_matches() == [match]
    end

    test "get_match!/1 returns the match with given id" do
      match = match_fixture()
      assert Matches.get_match!(match.id) == match
    end

    test "get_matches_by_user_id/1 returns for first_user_id" do
      match = match_fixture()
      |> Repo.preload(:first_user)

      matches = Matches.get_matches_by_user_id(match.first_user.id)

      assert Enum.count(matches) == 1
      assert Enum.at(matches, 0).id == match.id
    end

    test "get_matches_by_user_id/1 returns for second_user_id" do
      match = match_fixture()
      |> Repo.preload(:second_user)

      matches = Matches.get_matches_by_user_id(match.second_user.id)

      assert Enum.count(matches) == 1
      assert Enum.at(matches, 0).id == match.id
    end

    test "get_matches_by_user_id/1 returns nothing if no matches exist" do
      assert Matches.get_matches_by_user_id(1) == []
    end

    test "create_match/1 with valid data creates a match" do
      first_user = user_fixture(%{email: "u1@example.com"})
      second_user = user_fixture(%{email: "u2@example.com"})

      assert {:ok, %Match{} = match} = @valid_attrs
      |> Map.put(:first_user_id, first_user.id)
      |> Map.put(:second_user_id, second_user.id)
      |> Matches.create_match()

      match = match
      |> Repo.preload(:first_user)
      |> Repo.preload(:second_user)

      assert match.first_user == first_user
      assert match.second_user == second_user
    end

    test "create_match/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Matches.create_match(@invalid_attrs)
    end

    test "delete_match/1 deletes the match" do
      match = match_fixture()
      assert {:ok, %Match{}} = Matches.delete_match(match)
      assert_raise Ecto.NoResultsError, fn -> Matches.get_match!(match.id) end
    end

    test "change_match/1 returns a match changeset" do
      match = match_fixture()
      assert %Ecto.Changeset{} = Matches.change_match(match)
    end
  end
end
