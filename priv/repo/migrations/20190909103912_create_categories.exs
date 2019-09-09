defmodule Myshop.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string, non_null: true
      add :description, :text

      timestamps()
    end

    create unique_index(:categories, [:name])
  end
end
