defmodule MelodyMatch.Matches.Match do
  use Ecto.Schema
  import Ecto.Changeset

  alias MelodyMatch.Accounts.User

  schema "matches" do
    belongs_to :first_user, User
    belongs_to :second_user, User

    timestamps()
  end

  @doc false
  def changeset(match, attrs) do
    match
    |> cast(attrs, [:first_user_id, :second_user_id])
    |> validate_required([:first_user_id, :second_user_id])
  end
end
