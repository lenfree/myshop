defmodule Myshop.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :paid, :boolean, default: false, null: false
      add :notes, :text
      add :user_id, references(:users, on_delete: :nothing)
      add :product_id, references(:products, on_delete: :nothing)

      timestamps()
    end

    create index(:orders, [:user_id])
    create index(:orders, [:product_id])
  end
end
