defmodule Myshop.Repo.Migrations.ReferenceItemToCategory do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :category_id, references(:categories, on_delete: :nothing)
    end
  end
end
