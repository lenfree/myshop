defmodule Myshop.Repo.Migrations.CreateLenfrees do
  use Ecto.Migration

  def change do
    create table(:lenfrees) do
      add :name, :string
      add :items, :map

      timestamps()
    end

    create unique_index(:lenfrees, [:name])
  end
end
