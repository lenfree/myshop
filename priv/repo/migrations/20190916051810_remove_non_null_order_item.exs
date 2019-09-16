defmodule Myshop.Repo.Migrations.RemoveNonNullOrderItem do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      modify :product_items, :map
    end
  end
end
