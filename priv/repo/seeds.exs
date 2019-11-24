# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Myshop.Repo.insert!(%Myshop.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Myshop.Accounts

users = [
  %{
    first_name: "admin",
    last_name: "admin",
    credential: %{
      email: "admin@admin.example.com",
      password: "admin123"
    }
  }
]

Enum.each(users, fn user ->
  Accounts.create_user!(user)
end)
