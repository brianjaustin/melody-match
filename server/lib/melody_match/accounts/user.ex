defmodule MelodyMatch.Accounts.User do
  @moduledoc """
  Represents a registered user in Melody Match.

  ## Attribution

    Password security is based on the recommendations in
    * https://github.com/riverrun/comeonin/wiki/Hashing-passwords
    * https://github.com/riverrun/phauxth-example/blob/master/lib/forks_the_egg_sample/accounts/user.ex
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string, virtual: true, redact: true
    field :password_hash, :string, redact: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
    |> validate_email()
  end

  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> validate_email()
    |> validate_password(:password)
    |> put_pass_hash()
  end

  def update_password_changeset(user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_password(:password)
    |> put_pass_hash()
  end

  defp validate_email(changeset) do
    changeset
    # Python Regex from http://emailregex.com/
    |> validate_format(:email, ~r/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/)
    |> unique_constraint(:email)
  end

  defp validate_password(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, password -> 
      case NotQwerty123.PasswordStrength.strong_password?(password) do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || msg}]
      end
    end)
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    changeset
    |> change(Argon2.add_hash(password))
    |> change(%{password: nil})
  end

  defp put_pass_hash(changeset), do: changeset
end
