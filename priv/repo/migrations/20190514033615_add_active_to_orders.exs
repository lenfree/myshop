defmodule Myshop.Repo.Migrations.AddActiveToOrders do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :active, :boolean, default: false, null: false
    end
  end
end
