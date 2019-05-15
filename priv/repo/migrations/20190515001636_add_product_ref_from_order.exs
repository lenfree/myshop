defmodule Myshop.Repo.Migrations.AddProductRefFromOrder do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :product_id, references(:products)
    end
  end
end
