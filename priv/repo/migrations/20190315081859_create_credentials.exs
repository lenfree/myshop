defmodule Myshop.Repo.Migrations.CreateCredentials do
  use Ecto.Migration

  def change do
    create table(:credentials) do
      add :email, :string
      add :password, :string
      add :password_hash, :string

      timestamps()
    end
  end
end
