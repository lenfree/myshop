defmodule Myshop.Repo.Migrations.ModifyOrderJsonbProductItems do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      remove :product_id, references(:products, on_delete: :nothing)
      add :product_items, :map
      add :ordered_at, :utc_datetime, null: false, default: fragment("NOW()")
      add :state, :string
    end
  end
end
