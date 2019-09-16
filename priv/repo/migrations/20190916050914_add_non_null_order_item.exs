defmodule Myshop.Repo.Migrations.AddNonNullOrderItem do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      modify :product_items, :map, null: false
    end
  end
end
