defmodule Myshop.Repo.Migrations.RemoveProductRefFromOrder do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      remove :product_id
    end
  end
end
