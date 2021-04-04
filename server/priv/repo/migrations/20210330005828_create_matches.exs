defmodule MelodyMatch.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add :first_user_id, references(:users, on_delete: :nothing), null: false
      add :second_user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:matches, [:first_user_id])
    create index(:matches, [:second_user_id])
  end
end
