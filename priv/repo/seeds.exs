# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Touiteur.Repo.insert!(%Touiteur.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Touiteur.{Repo, Accounts}

Repo.insert!(%Accounts.User{
  name: "John",
  email: "john.doe@mail.net",
  # "password"
  hashed_password: "$2b$12$jIGp.Jl0N5eGUFiTuqFHkeudSL8LGW1xz0QyiyHkyazYo2JbqIZam"
})

Repo.insert!(%Accounts.User{
  name: "Jane",
  email: "jane.doe@mail.net",
  # "password"
  hashed_password: "$2b$12$jIGp.Jl0N5eGUFiTuqFHkeudSL8LGW1xz0QyiyHkyazYo2JbqIZam"
})
