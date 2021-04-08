# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     MelodyMatch.Repo.insert!(%MelodyMatch.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#
alias MelodyMatch.Repo
alias MelodyMatch.Accounts.User
alias MelodyMatch.Matches.Match

defmodule Inject do

  def user(name, email, pass) do
    hash = Argon2.hash_pwd_salt(pass)
    Repo.insert!(%User{name: name, email: email, password_hash: hash})
  end
end

alice = Inject.user("alice", "alice@gmail.com", "testpass1")
bob = Inject.user("bob", "bob@hotmail.com", "testpass2")


Repo.insert!(%Match{first_user_id: alice.id, second_user_id: bob.id})
